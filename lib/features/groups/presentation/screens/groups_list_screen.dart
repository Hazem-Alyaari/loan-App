import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/groups/application/providers/group_providers.dart';
import 'package:loan/features/groups/domain/models/group_model.dart';
import 'package:loan/features/notifications/application/providers/notification_providers.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(userGroupsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مجموعاتي',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'إدارة المصروفات الجماعية',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.push('/profile'),
                            icon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                          // Notifications bell
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.push('/notifications'),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.textPrimary,
                                  size: 26,
                                ),
                              ),
                              if ((unreadCount.value ?? 0) > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${unreadCount.value}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          // Sign out
                          IconButton(
                            onPressed: () => ref
                                .read(authControllerProvider.notifier)
                                .signOut(),
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Groups list ──────────────────────────────
              groupsAsync.when(
                data: (groups) {
                  if (groups.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group_add_outlined,
                              size: 80,
                              color:
                                  AppColors.textHint.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'لا توجد مجموعات بعد',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'أنشئ أول مجموعة للبدء',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final group = groups[index];
                          return _GroupCard(group: group);
                        },
                        childCount: groups.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: Center(
                    child: Text('خطأ: $err',
                        style:
                            const TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-group'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('مجموعة جديدة'),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final memberCount = group.memberIds.length;

    return GlassCard(
      onTap: () => context.push('/groups/${group.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Group icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.group_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$memberCount عضو • ${group.currencyCode}',
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
