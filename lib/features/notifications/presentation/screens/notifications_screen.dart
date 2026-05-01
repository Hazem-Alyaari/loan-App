import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/locale/l10n_context.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/notifications/application/providers/notification_providers.dart';
import 'package:loan/features/notifications/domain/models/app_notification.dart';
import 'package:loan/l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  static const int _defaultPageSize = 8;
  final List<AppNotification> _items = [];
  bool _loading = false;
  bool _hasMore = true;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastDoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    if (!reset && !_hasMore) return;
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    try {
      final page = await ref
          .read(notificationRepositoryProvider)
          .fetchUserNotificationsPage(
            uid,
            startAfter: reset ? null : _lastDoc,
            limit: _defaultPageSize,
          );
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(page.items);
        _lastDoc = page.lastDoc;
        _hasMore = page.hasMore;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final uid = ref.watch(authStateProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationControllerProvider.notifier).markAllAsRead();
            },
            child: Text(l10n.markAllRead),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: uid == null
            ? Center(
                child: Text(l10n.userNotLoggedIn,
                    style: const TextStyle(color: AppColors.textSecondary)),
              )
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final l10n = context.l10n;
    if (_items.isEmpty && _loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: AppColors.textHint.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.notifEmptyTitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notifEmptySub,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _items.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: OutlinedButton(
                onPressed: _loading ? null : () => _load(),
                child: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.loadMore),
              ),
            ),
          );
        }

        final notif = _items[index];
        return _NotificationTile(notification: notif, l10n: l10n);
      },
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;
  final AppLocalizations l10n;

  const _NotificationTile({required this.notification, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (IconData icon, Color color) = switch (notification.type) {
      NotificationType.approvalRequest => (
          Icons.pending_actions_rounded,
          AppColors.warning
        ),
      NotificationType.transactionApproved => (
          Icons.check_circle_rounded,
          AppColors.success
        ),
      NotificationType.transactionRejected => (
          Icons.cancel_rounded,
          AppColors.error
        ),
      NotificationType.balanceUpdated => (
          Icons.account_balance_wallet_rounded,
          AppColors.info
        ),
    };

    return GlassCard(
      borderColor: notification.isRead
          ? null
          : AppColors.primary.withValues(alpha: 0.3),
      onTap: () {
        if (!notification.isRead) {
          ref
              .read(notificationControllerProvider.notifier)
              .markAsRead(notification.id);
        }
        // Navigate to related transaction if available
        if (notification.groupId != null &&
            notification.transactionId != null) {
          context.push(
            '/groups/${notification.groupId}/transactions/${notification.transactionId}',
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _timeAgo(notification.createdAt, l10n),
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date, AppLocalizations l10n) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return l10n.timeNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
    return l10n.timeDate(date.day, date.month, date.year);
  }
}
