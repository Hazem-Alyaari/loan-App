import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/core/widgets/gradient_button.dart';
import 'package:loan/core/widgets/status_badge.dart';
import 'package:loan/features/transactions/application/providers/transaction_providers.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  final String groupId;
  final String transactionId;

  const TransactionDetailsScreen({
    super.key,
    required this.groupId,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(
      transactionDetailProvider(
        (groupId: groupId, transactionId: transactionId),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المعاملة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: txAsync.when(
          data: (tx) {
            final statusType = switch (tx.status) {
              TransactionStatus.approved => StatusType.success,
              TransactionStatus.rejected => StatusType.error,
              TransactionStatus.pending => StatusType.warning,
              TransactionStatus.cancelled => StatusType.neutral,
            };

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Amount header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.accentAlt.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        StatusBadge(
                          label: _statusLabel(tx.status),
                          type: statusType,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _transactionTypeLabel(tx.type),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details card
                  GlassCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.person_outline,
                          label: 'الدائن',
                          value: tx.creditorName ?? tx.creditorUserId,
                        ),
                        const Divider(color: Color(0xFF2A2A45)),
                        _DetailRow(
                          icon: Icons.person_outline,
                          label: 'المدين',
                          value: tx.debtorName ?? tx.debtorUserId,
                        ),
                        if (tx.note.isNotEmpty) ...[
                          const Divider(color: Color(0xFF2A2A45)),
                          _DetailRow(
                            icon: Icons.notes_outlined,
                            label: 'الملاحظة',
                            value: tx.note,
                          ),
                        ],
                        const Divider(color: Color(0xFF2A2A45)),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'تاريخ الإنشاء',
                          value: _formatDate(tx.createdAt),
                        ),
                        if (tx.approvedAt != null) ...[
                          const Divider(color: Color(0xFF2A2A45)),
                          _DetailRow(
                            icon: Icons.check_circle_outline,
                            label: 'تاريخ الموافقة',
                            value: _formatDate(tx.approvedAt!),
                          ),
                        ],
                        if (tx.rejectedAt != null) ...[
                          const Divider(color: Color(0xFF2A2A45)),
                          _DetailRow(
                            icon: Icons.cancel_outlined,
                            label: 'تاريخ الرفض',
                            value: _formatDate(tx.rejectedAt!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons (only if pending)
                  if (tx.status == TransactionStatus.pending) ...[
                    GradientButton(
                      text: 'موافقة',
                      icon: Icons.check_rounded,
                      onPressed: () {
                        ref
                            .read(transactionControllerProvider.notifier)
                            .approveTransaction(groupId, transactionId);
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref
                              .read(transactionControllerProvider.notifier)
                              .rejectTransaction(groupId, transactionId);
                        },
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.error),
                        label: const Text('رفض',
                            style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Text('خطأ: $e',
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

String _statusLabel(TransactionStatus status) {
  return switch (status) {
    TransactionStatus.approved => 'موافق',
    TransactionStatus.rejected => 'مرفوض',
    TransactionStatus.pending => 'معلّق',
    TransactionStatus.cancelled => 'ملغي',
  };
}

String _transactionTypeLabel(TransactionType type) {
  return switch (type) {
    TransactionType.loan => 'قرض',
    TransactionType.repayment => 'سداد',
    TransactionType.correction => 'تصحيح',
  };
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textHint, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
