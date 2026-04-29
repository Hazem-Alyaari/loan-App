import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/core/widgets/status_badge.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/groups/application/providers/group_providers.dart';
import 'package:loan/features/transactions/application/providers/transaction_providers.dart';

class GroupDetailsScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: groupAsync.when(
          data: (group) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppColors.surface,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.accentAlt.withValues(alpha: 0.2),
                            AppColors.surface,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${group.memberIds.length} عضو • ${group.currencyCode}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textHint,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'الأرصدة'),
                      Tab(text: 'المعاملات'),
                      Tab(text: 'الأعضاء'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _BalancesTab(groupId: widget.groupId),
                  _TransactionsTab(groupId: widget.groupId),
                  _MembersTab(groupId: widget.groupId),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, _) => Center(
            child: Text('خطأ: $err',
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final created = await context.push<bool>(
            '/groups/${widget.groupId}/create-transaction',
          );
          if (created == true && mounted) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('تمت إضافة المعاملة بنجاح'),
              ),
            );
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('معاملة جديدة'),
      ),
    );
  }
}

// ─── Balances Tab ───────────────────────────────────────────────────────────
class _BalancesTab extends ConsumerWidget {
  final String groupId;
  const _BalancesTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider).value;
    final txAsync = ref.watch(groupTransactionsProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final groupAsync = ref.watch(groupDetailProvider(groupId));

    if (authUser == null) {
      return const Center(
        child: Text('المستخدم غير مسجل الدخول',
            style: TextStyle(color: AppColors.textHint)),
      );
    }

    if (groupAsync.isLoading || membersAsync.isLoading || txAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (groupAsync.hasError) {
      return Center(
        child: Text('خطأ: ${groupAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    if (membersAsync.hasError) {
      return Center(
        child: Text('خطأ: ${membersAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    if (txAsync.hasError) {
      return Center(
        child: Text('خطأ: ${txAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    final group = groupAsync.value!;
    final members = membersAsync.value ?? [];
    final transactions = txAsync.value ?? [];

    final memberNameMap = <String, String>{};
    for (final member in members) {
      memberNameMap[member.userId] = member.userName ?? member.userId;
    }

    final summaryByUser = <String, _BalanceSummary>{};
    for (final member in members) {
      summaryByUser[member.userId] = const _BalanceSummary();
    }

    for (final tx in transactions) {
      if (tx.status != TransactionStatus.approved) continue;
      final creditor = summaryByUser[tx.creditorUserId] ?? const _BalanceSummary();
      final debtor = summaryByUser[tx.debtorUserId] ?? const _BalanceSummary();
      summaryByUser[tx.creditorUserId] =
          creditor.copyWith(receivable: creditor.receivable + tx.amount);
      summaryByUser[tx.debtorUserId] =
          debtor.copyWith(payable: debtor.payable + tx.amount);
    }

    final me = summaryByUser[authUser.uid] ?? const _BalanceSummary();
    final myNet = me.net;
    final entries = summaryByUser.entries.toList()
      ..sort((a, b) => b.value.net.compareTo(a.value.net));

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'رصيدي',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'عرض رصيدك الحالي فقط',
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
              const SizedBox(height: 14),
              _balanceLine(
                title: 'لك على الناس',
                value: me.receivable,
                currency: group.currencyCode,
                color: AppColors.success,
              ),
              const SizedBox(height: 8),
              _balanceLine(
                title: 'عليك للناس',
                value: me.payable,
                currency: group.currencyCode,
                color: AppColors.error,
              ),
              const Divider(height: 24, color: Color(0xFF2A2A45)),
              _balanceLine(
                title: 'الصافي',
                value: myNet,
                currency: group.currencyCode,
                color: myNet >= 0 ? AppColors.success : AppColors.error,
                signed: true,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 4),
          child: Text(
            'تفصيل الرصيد حسب الشخص',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (final entry in entries)
          GlassCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    (memberNameMap[entry.key] ?? entry.key)
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberNameMap[entry.key] ?? entry.key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'له: ${entry.value.receivable.toStringAsFixed(2)} • عليه: ${entry.value.payable.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${entry.value.net >= 0 ? '+' : ''}${entry.value.net.toStringAsFixed(2)} ${group.currencyCode}',
                  style: TextStyle(
                    color: entry.value.net >= 0
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Transactions Tab ───────────────────────────────────────────────────────
class _TransactionsTab extends ConsumerWidget {
  final String groupId;
  const _TransactionsTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(groupTransactionsProvider(groupId));

    return txAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Text('لا توجد معاملات بعد',
                style: TextStyle(color: AppColors.textHint)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            final statusType = switch (tx.status) {
              TransactionStatus.approved => StatusType.success,
              TransactionStatus.rejected => StatusType.error,
              TransactionStatus.pending => StatusType.warning,
              TransactionStatus.cancelled => StatusType.neutral,
            };

            return GlassCard(
              onTap: () => context.push(
                '/groups/$groupId/transactions/${tx.id}',
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          tx.type == TransactionType.loan
                              ? Icons.monetization_on_outlined
                              : tx.type == TransactionType.repayment
                                  ? Icons.payments_outlined
                                  : Icons.edit_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.note.isNotEmpty ? tx.note : _transactionTypeLabel(tx.type),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tx.creditorName ?? tx.creditorUserId} → ${tx.debtorName ?? tx.debtorUserId}',
                              style: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StatusBadge(
                            label: _statusLabel(tx.status),
                            type: statusType,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('خطأ: $e',
            style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}

// ─── Members Tab ────────────────────────────────────────────────────────────
class _MembersTab extends ConsumerStatefulWidget {
  final String groupId;
  const _MembersTab({required this.groupId});

  @override
  ConsumerState<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<_MembersTab> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final authUser = ref.watch(authStateProvider).value;
    final controllerState = ref.watch(groupControllerProvider);
    final isAdding = controllerState is AsyncLoading;

    return membersAsync.when(
      data: (members) {
        final currentRole = members
            .where((m) => m.userId == authUser?.uid)
            .map((m) => m.role)
            .firstOrNull;
        final canManageMembers =
            currentRole == MemberRole.owner || currentRole == MemberRole.admin;

        return Column(
          children: [
            if (canManageMembers)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'اسم العضو',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              hintText: 'إضافة عضو برقم الهاتف',
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: isAdding
                              ? null
                              : () async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  final name = _nameController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  if (name.isEmpty) {
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('اسم العضو مطلوب'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  }
                                  if (phone.isEmpty) {
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('رقم الهاتف مطلوب'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    await ref
                                        .read(groupControllerProvider.notifier)
                                        .addMemberByPhone(
                                          groupId: widget.groupId,
                                          fullName: name,
                                          phoneNumber: phone,
                                        );
                                    _nameController.clear();
                                    _phoneController.clear();
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تمت إضافة العضو. كلمة المرور الافتراضية: 12345678',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                },
                          child: isAdding
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('إضافة'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: members.isEmpty
                  ? const Center(
                      child: Text(
                        'لا يوجد أعضاء',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final roleType = switch (member.role) {
                          MemberRole.owner => StatusType.info,
                          MemberRole.admin => StatusType.warning,
                          MemberRole.member => StatusType.neutral,
                        };

                        return GlassCard(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.2),
                                child: Text(
                                  (member.userName ?? member.userId)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.userName ?? member.userId,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if ((member.userPhone ?? '').isNotEmpty)
                                      Text(
                                        member.userPhone!,
                                        style: const TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 12,
                                        ),
                                      )
                                    else if ((member.userEmail ?? '').isNotEmpty)
                                      Text(
                                        member.userEmail!,
                                        style: const TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              StatusBadge(
                                label: _memberRoleLabel(member.role),
                                type: roleType,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('خطأ: $e',
            style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}

String _memberRoleLabel(MemberRole role) {
  return switch (role) {
    MemberRole.owner => 'المالك',
    MemberRole.admin => 'مشرف',
    MemberRole.member => 'عضو',
  };
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

class _BalanceSummary {
  final double receivable;
  final double payable;

  const _BalanceSummary({
    this.receivable = 0,
    this.payable = 0,
  });

  double get net => receivable - payable;

  _BalanceSummary copyWith({
    double? receivable,
    double? payable,
  }) {
    return _BalanceSummary(
      receivable: receivable ?? this.receivable,
      payable: payable ?? this.payable,
    );
  }
}

Widget _balanceLine({
  required String title,
  required double value,
  required String currency,
  required Color color,
  bool signed = false,
}) {
  final display = signed
      ? '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)} $currency'
      : '${value.toStringAsFixed(2)} $currency';
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
      Text(
        display,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
