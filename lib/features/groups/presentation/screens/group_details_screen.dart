import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/core/widgets/status_badge.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/groups/application/providers/group_providers.dart';
import 'package:loan/features/transactions/application/providers/transaction_providers.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';

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
    final approvedCount = transactions
        .where((t) => t.status == TransactionStatus.approved)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'رصيدي',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF333355)),
                    ),
                    child: Text(
                      '$approvedCount معاملة معتمدة',
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'ملخص واضح لرصيدك الحالي داخل هذه المجموعة',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      title: 'لك على الناس',
                      value:
                          '${me.receivable.toStringAsFixed(2)} ${group.currencyCode}',
                      color: AppColors.success,
                      icon: Icons.south_west_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metricCard(
                      title: 'عليك للناس',
                      value: '${me.payable.toStringAsFixed(2)} ${group.currencyCode}',
                      color: AppColors.error,
                      icon: Icons.north_east_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF333355)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'الصافي',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${myNet >= 0 ? '+' : ''}${myNet.toStringAsFixed(2)} ${group.currencyCode}',
                      style: TextStyle(
                        color: myNet >= 0 ? AppColors.success : AppColors.error,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Text(
            'تفصيل الرصيد حسب الشخص',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (approvedCount == 0)
          const GlassCard(
            child: Text(
              'لا توجد معاملات معتمدة بعد، لذلك لا يوجد رصيد محسوب حاليا.',
              style: TextStyle(color: AppColors.textHint),
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _tinyBalancePill(
                            label:
                                'له ${entry.value.receivable.toStringAsFixed(2)}',
                            color: AppColors.success,
                          ),
                          _tinyBalancePill(
                            label: 'عليه ${entry.value.payable.toStringAsFixed(2)}',
                            color: AppColors.error,
                          ),
                        ],
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
    return _PaginatedTransactionsList(groupId: groupId);
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
  static const int _maxMemberNameLength = 50;
  static const int _maxPhoneLength = 20;

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final currentMemberAsync = ref.watch(currentGroupMemberProvider(widget.groupId));
    final controllerState = ref.watch(groupControllerProvider);
    final isAdding = controllerState is AsyncLoading;
    final canManageMembers = switch (currentMemberAsync.value?.role) {
      MemberRole.owner || MemberRole.admin => true,
      _ => false,
    };

    return membersAsync.when(
      data: (members) => Column(
        children: [
            if (canManageMembers)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isAdding ? null : _showAddMemberDialog,
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('عضو جديد'),
                      ),
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
    ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text(
          'خطأ: $e',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Future<void> _showAddMemberDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);

    final added = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إضافة عضو جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: _maxMemberNameLength,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxMemberNameLength),
                ],
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
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: _maxPhoneLength,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxPhoneLength),
                ],
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'رقم الهاتف',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
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
                if (name.length > _maxMemberNameLength) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('اسم العضو طويل جدا'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                if (phone.length > _maxPhoneLength) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('رقم الهاتف طويل جدا'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('رقم الهاتف مطلوب'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(groupControllerProvider.notifier).addMemberByPhone(
                        groupId: widget.groupId,
                        fullName: name,
                        phoneNumber: phone,
                      );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(true);
                  }
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();

    if (added == true && mounted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('تمت إضافة العضو بنجاح'),
        ),
      );
    }
  }
}

class _PaginatedTransactionsList extends ConsumerStatefulWidget {
  final String groupId;
  const _PaginatedTransactionsList({required this.groupId});

  @override
  ConsumerState<_PaginatedTransactionsList> createState() =>
      _PaginatedTransactionsListState();
}

class _PaginatedTransactionsListState
    extends ConsumerState<_PaginatedTransactionsList> {
  final List<TransactionModel> _items = [];
  bool _loading = false;
  bool _hasMore = true;
  dynamic _lastDoc;
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(groupMembersProvider(widget.groupId)).value ?? [];
    final filteredItems = _selectedUserId == null
        ? _items
        : _items
            .where((tx) =>
                tx.creditorUserId == _selectedUserId ||
                tx.debtorUserId == _selectedUserId)
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333355)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedUserId,
                isExpanded: true,
                dropdownColor: AppColors.surfaceLight,
                hint: const Text(
                  'تصفية حسب المستخدم',
                  style: TextStyle(color: AppColors.textHint),
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textHint,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('كل المستخدمين'),
                  ),
                  ...members.map(
                    (m) => DropdownMenuItem<String?>(
                      value: m.userId,
                      child: Text(m.userName ?? m.userId),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedUserId = value),
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildTransactionsList(filteredItems),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(List<TransactionModel> list) {
    if (_items.isEmpty && _loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (list.isEmpty) {
      return Center(
        child: Text(
          _selectedUserId == null
              ? 'لا توجد معاملات بعد'
              : 'لا توجد معاملات لهذا المستخدم',
          style: const TextStyle(color: AppColors.textHint),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: list.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= list.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: OutlinedButton(
                onPressed: _loading ? null : _load,
                child: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('تحميل المزيد'),
              ),
            ),
          );
        }

        final tx = list[index];
        final statusType = switch (tx.status) {
          TransactionStatus.approved => StatusType.success,
          TransactionStatus.rejected => StatusType.error,
          TransactionStatus.pending => StatusType.warning,
          TransactionStatus.cancelled => StatusType.neutral,
        };

        return GlassCard(
          onTap: () => context.push('/groups/${widget.groupId}/transactions/${tx.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
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
                      StatusBadge(label: _statusLabel(tx.status), type: statusType),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    if (!reset && !_hasMore) return;
    setState(() => _loading = true);
    final repo = ref.read(transactionRepositoryProvider);
    final page = await repo.fetchGroupTransactionsPage(
      widget.groupId,
      startAfter: reset ? null : _lastDoc,
      limit: 5,
    );
    if (!mounted) return;
    setState(() {
      if (reset) _items.clear();
      _items.addAll(page.items);
      _lastDoc = page.lastDoc;
      _hasMore = page.hasMore;
      _loading = false;
    });
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

Widget _metricCard({
  required String title,
  required String value,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF333355)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

Widget _tinyBalancePill({
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
