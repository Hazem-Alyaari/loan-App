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
    _tabController = TabController(length: 4, vsync: this);
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
                  expandedHeight: 240,
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
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 56),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _headerMetaChip(
                                        icon: Icons.group_outlined,
                                        text: '${group.memberIds.length} عضو',
                                      ),
                                      _headerMetaChip(
                                        icon: Icons.payments_outlined,
                                        text: group.currencyCode,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                      Tab(text: 'التحليل'),
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
                  _MonthlyAnalysisTab(groupId: widget.groupId),
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
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add_rounded),
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
    final currentMemberAsync = ref.watch(currentGroupMemberProvider(groupId));

    if (authUser == null) {
      return const Center(
        child: Text('المستخدم غير مسجل الدخول',
            style: TextStyle(color: AppColors.textHint)),
      );
    }
    final myApprovedTxAsync = ref.watch(
      memberApprovedTransactionsProvider((groupId: groupId, userId: authUser.uid)),
    );

    if (groupAsync.isLoading ||
        membersAsync.isLoading ||
        currentMemberAsync.isLoading ||
        txAsync.isLoading ||
        myApprovedTxAsync.isLoading) {
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
    if (currentMemberAsync.hasError) {
      return Center(
        child: Text('خطأ: ${currentMemberAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    if (myApprovedTxAsync.hasError) {
      return Center(
        child: Text('خطأ: ${myApprovedTxAsync.error}',
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
    final canViewAllBalances = switch (currentMemberAsync.value?.role) {
      MemberRole.owner || MemberRole.admin => true,
      _ => false,
    };
    final memberNameMap = <String, String>{};
    for (final member in members) {
      memberNameMap[member.userId] = member.userName ?? member.userId;
    }

    final approvedTransactions = (txAsync.value ?? [])
        .where((tx) => tx.status == TransactionStatus.approved)
        .toList();
    final netByUserFromTx = _buildNetByUser(approvedTransactions);

    final balances = group.balances;
    final myPairwiseFromTx =
        _buildPairwiseForMember(myApprovedTxAsync.value ?? const [], authUser.uid);
    final myReceivable = myPairwiseFromTx.values
        .where((value) => value > 0)
        .fold<double>(0, (sum, value) => sum + value);
    final myPayable = myPairwiseFromTx.values
        .where((value) => value < 0)
        .fold<double>(0, (sum, value) => sum + value.abs());
    final myNet = myReceivable - myPayable;

    final entries = balances.entries
        .where((entry) => canViewAllBalances || entry.key == authUser.uid)
        .map(
          (entry) => MapEntry(
            entry.key,
            netByUserFromTx[entry.key] ?? 0.0,
          ),
        )
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
                      canViewAllBalances ? 'رصيد كل الأعضاء' : 'رصيدك الحالي',
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
                      value: '${myReceivable.toStringAsFixed(2)} ${group.currencyCode}',
                      color: AppColors.success,
                      icon: Icons.south_west_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metricCard(
                      title: 'عليك للناس',
                      value: '${myPayable.toStringAsFixed(2)} ${group.currencyCode}',
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
        Padding(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Text(
            canViewAllBalances ? 'أرصدة الأعضاء' : 'رصيدك',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (entries.isEmpty)
          const GlassCard(
            child: Text(
              'لا توجد أرصدة متاحة حاليا.',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
        for (final entry in entries)
          GlassCard(
            onTap: () => _showMemberSettlementSheet(
              context,
              ref: ref,
              groupId: groupId,
              memberId: entry.key,
              memberName: memberNameMap[entry.key] ?? entry.key,
              currencyCode: group.currencyCode,
              memberNameMap: memberNameMap,
            ),
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
                        entry.value > 0
                            ? 'له على المجموعة'
                            : entry.value < 0
                                ? 'عليه للمجموعة'
                                : 'رصيد متوازن',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value > 0
                            ? 'له على المجموعة'
                            : entry.value < 0
                                ? 'عليه للمجموعة'
                                : 'متوازن',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${entry.value >= 0 ? '+' : ''}${entry.value.toStringAsFixed(2)} ${group.currencyCode}',
                  style: TextStyle(
                    color: entry.value >= 0
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

void _showMemberSettlementSheet(
  BuildContext context, {
  required WidgetRef ref,
  required String groupId,
  required String memberId,
  required String memberName,
  required String currencyCode,
  required Map<String, String> memberNameMap,
}) {
  final future = ref.read(transactionRepositoryProvider).fetchMemberApprovedTransactions(
        groupId,
        memberUserId: memberId,
      );

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FutureBuilder<List<TransactionModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 260,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          if (snapshot.hasError) {
            return SizedBox(
              height: 260,
              child: Center(
                child: Text(
                  'خطأ: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }

          final pairwiseForMember =
              _buildPairwiseForMember(snapshot.data ?? [], memberId);
          final positiveEntries = pairwiseForMember.entries
              .where((entry) => entry.value > 0)
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final negativeEntries = pairwiseForMember.entries
              .where((entry) => entry.value < 0)
              .toList()
            ..sort((a, b) => a.value.compareTo(b.value));
          final totalReceivable = positiveEntries.fold<double>(
            0,
            (sum, entry) => sum + entry.value,
          );
          final totalPayable = negativeEntries.fold<double>(
            0,
            (sum, entry) => sum + entry.value.abs(),
          );
          final net = totalReceivable - totalPayable;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded,
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تسوية العضو • $memberName',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (final entry in positiveEntries)
                      _settlementRow(
                        label: 'له على ${memberNameMap[entry.key] ?? entry.key}',
                        value: entry.value,
                        currencyCode: currencyCode,
                        color: AppColors.success,
                      ),
                    for (final entry in negativeEntries)
                      _settlementRow(
                        label: 'عليه لـ ${memberNameMap[entry.key] ?? entry.key}',
                        value: entry.value.abs(),
                        currencyCode: currencyCode,
                        color: AppColors.error,
                      ),
                    if (positiveEntries.isEmpty && negativeEntries.isEmpty)
                      const Text(
                        'لا توجد تسويات مفتوحة لهذا العضو.',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF333355)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الملخص',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'إجمالي له: ${totalReceivable.toStringAsFixed(2)} $currencyCode',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          Text(
                            'إجمالي عليه: ${totalPayable.toStringAsFixed(2)} $currencyCode',
                            style: const TextStyle(color: AppColors.error),
                          ),
                          Text(
                            'الصافي: ${net >= 0 ? '+' : ''}${net.toStringAsFixed(2)} $currencyCode',
                            style: TextStyle(
                              color: net >= 0 ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Map<String, double> _buildPairwiseForMember(
  List<TransactionModel> approvedTransactions,
  String memberId,
) {
  final result = <String, double>{};
  for (final tx in approvedTransactions) {
    if (tx.creditorUserId == memberId) {
      result[tx.debtorUserId] = (result[tx.debtorUserId] ?? 0) + tx.amount;
    } else if (tx.debtorUserId == memberId) {
      result[tx.creditorUserId] = (result[tx.creditorUserId] ?? 0) - tx.amount;
    }
  }
  result.removeWhere((_, value) => value.abs() < 0.0001);
  return result;
}

Map<String, double> _buildNetByUser(List<TransactionModel> approvedTransactions) {
  final result = <String, double>{};
  for (final tx in approvedTransactions) {
    result[tx.creditorUserId] = (result[tx.creditorUserId] ?? 0) + tx.amount;
    result[tx.debtorUserId] = (result[tx.debtorUserId] ?? 0) - tx.amount;
  }
  return result;
}

Widget _settlementRow({
  required String label,
  required double value,
  required String currencyCode,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} $currencyCode',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

String _settlementTimeRemaining(DateTime expiresAt, DateTime now) {
  if (expiresAt.isBefore(now)) {
    return 'انتهت صلاحية الاقتراح — يمكن إعادة الاكتشاف';
  }
  final left = expiresAt.difference(now);
  final h = left.inHours;
  final m = left.inMinutes.remainder(60);
  if (h > 0) {
    return 'متبقي: $h ساعة و $m دقيقة';
  }
  return 'متبقي: $m دقيقة';
}

Widget _proposalApprovalPill(String label, String status) {
  final color = switch (status) {
    'approved' => AppColors.success,
    'rejected' => AppColors.error,
    _ => AppColors.warning,
  };
  final text = switch (status) {
    'approved' => 'موافق',
    'rejected' => 'رافض',
    _ => 'معلّق',
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      '$label: $text',
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
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

class _MonthlyAnalysisTab extends ConsumerWidget {
  final String groupId;
  const _MonthlyAnalysisTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider).value;
    final txAsync = ref.watch(groupTransactionsProvider(groupId));
    final currentMemberAsync = ref.watch(currentGroupMemberProvider(groupId));
    final groupAsync = ref.watch(groupDetailProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final proposalsAsync = ref.watch(groupSettlementProposalsProvider(groupId));

    if (authUser == null) {
      return const Center(
        child: Text('المستخدم غير مسجل الدخول',
            style: TextStyle(color: AppColors.textHint)),
      );
    }

    if (txAsync.isLoading ||
        currentMemberAsync.isLoading ||
        groupAsync.isLoading ||
        membersAsync.isLoading ||
        proposalsAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (txAsync.hasError) {
      return Center(
        child: Text('خطأ: ${txAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    if (currentMemberAsync.hasError) {
      return Center(
        child: Text('خطأ: ${currentMemberAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
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
    if (proposalsAsync.hasError) {
      return Center(
        child: Text('خطأ: ${proposalsAsync.error}',
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    final group = groupAsync.value!;
    final members = membersAsync.value ?? const [];
    final memberNameMap = <String, String>{
      for (final m in members) m.userId: (m.userName ?? m.userId),
    };
    final proposals = proposalsAsync.value ?? const [];
    final canViewAll = switch (currentMemberAsync.value?.role) {
      MemberRole.owner || MemberRole.admin => true,
      _ => false,
    };
    final approvedTx = (txAsync.value ?? [])
        .where((tx) => tx.status == TransactionStatus.approved)
        .where(
          (tx) =>
              canViewAll ||
              tx.creditorUserId == authUser.uid ||
              tx.debtorUserId == authUser.uid,
        )
        .toList();

    final monthly = <String, _MonthlyMetrics>{};
    for (final tx in approvedTx) {
      final key =
          '${tx.createdAt.year}-${tx.createdAt.month.toString().padLeft(2, '0')}';
      final current = monthly[key] ?? const _MonthlyMetrics();
      final incoming = tx.creditorUserId == authUser.uid ? tx.amount : 0.0;
      final outgoing = tx.debtorUserId == authUser.uid ? tx.amount : 0.0;
      monthly[key] = current.copyWith(
        totalAmount: current.totalAmount + tx.amount,
        incoming: current.incoming + incoming,
        outgoing: current.outgoing + outgoing,
        count: current.count + 1,
      );
    }

    final monthEntries = monthly.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'اقتراح تصفية الديون الدائرية',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final created = await ref
                          .read(transactionControllerProvider.notifier)
                          .createSettlementProposals(groupId);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            created > 0
                                ? 'تم إنشاء $created اقتراح/اقتراحات تسوية (صلاحية 12 ساعة)'
                                : 'لا توجد حلقات جديدة للتسوية حاليا',
                          ),
                        ),
                      );
                    },
                    child: const Text('اكتشاف'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'أي عضو يمكنه البحث عن حلقة ديون وإنشاء اقتراح. الاقتراح يظهر لجميع الأعضاء وينتهي تلقائياً بعد 12 ساعة إن لم يكتمل التصويت.',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (proposals.isNotEmpty)
          ...proposals.map(
            (proposal) {
              final now = DateTime.now();
              final isParticipant =
                  proposal.participants.contains(authUser.uid);
              final canVote = isParticipant &&
                  (proposal.approvals[authUser.uid] ?? 'pending') ==
                      'pending' &&
                  !proposal.expiresAt.isBefore(now);
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    'اقتراح تسوية • ${proposal.settlementAmount.toStringAsFixed(2)} ${group.currencyCode}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    proposal.participants
                        .map((id) => memberNameMap[id] ?? id)
                        .join(' • '),
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _settlementTimeRemaining(proposal.expiresAt, now),
                    style: TextStyle(
                      color: proposal.expiresAt.isBefore(now)
                          ? AppColors.error
                          : AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: proposal.participants
                        .map(
                          (id) => _proposalApprovalPill(
                            memberNameMap[id] ?? id,
                            proposal.approvals[id] ?? 'pending',
                          ),
                        )
                        .toList(),
                  ),
                  if (!isParticipant)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'للاطلاع فقط — التصويت للأطراف المعنية بالحلقة',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (canVote)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(transactionControllerProvider.notifier)
                                  .respondToSettlementProposal(
                                    groupId: groupId,
                                    proposalId: proposal.id,
                                    approve: false,
                                  ),
                              icon: const Icon(Icons.close_rounded,
                                  color: AppColors.error),
                              label: const Text(
                                'رفض',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(transactionControllerProvider.notifier)
                                  .respondToSettlementProposal(
                                    groupId: groupId,
                                    proposalId: proposal.id,
                                    approve: true,
                                  ),
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('موافقة'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
            },
          ),
        if (monthEntries.isEmpty)
          const GlassCard(
            child: Text(
              'لا توجد معاملات معتمدة للتحليل الشهري (أو لا تظهر لصلاحياتك الحالية)',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
        for (final entry in monthEntries)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _formatMonthKey(entry.key),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.value.count} معاملات',
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _metricCard(
                  title: 'إجمالي الشهر',
                  value:
                      '${entry.value.totalAmount.toStringAsFixed(2)} ${group.currencyCode}',
                  color: AppColors.info,
                  icon: Icons.stacked_line_chart_rounded,
                ),
                if (!canViewAll) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          title: 'لك',
                          value:
                              '${entry.value.incoming.toStringAsFixed(2)} ${group.currencyCode}',
                          color: AppColors.success,
                          icon: Icons.south_west_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _metricCard(
                          title: 'عليك',
                          value:
                              '${entry.value.outgoing.toStringAsFixed(2)} ${group.currencyCode}',
                          color: AppColors.error,
                          icon: Icons.north_east_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
      ],
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
    final authUser = ref.watch(authStateProvider).value;
    final currentMember = ref.watch(currentGroupMemberProvider(widget.groupId)).value;
    final canViewAllTransactions = switch (currentMember?.role) {
      MemberRole.owner || MemberRole.admin => true,
      _ => false,
    };
    final effectiveUserIdFilter =
        canViewAllTransactions ? _selectedUserId : authUser?.uid;
    final members = ref.watch(groupMembersProvider(widget.groupId)).value ?? [];
    final filteredItems = effectiveUserIdFilter == null
        ? _items
        : _items
            .where((tx) =>
                tx.creditorUserId == effectiveUserIdFilter ||
                tx.debtorUserId == effectiveUserIdFilter)
            .toList();

    return Column(
      children: [
        if (canViewAllTransactions)
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
          child: _buildTransactionsList(
            filteredItems,
            canViewAllTransactions: canViewAllTransactions,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(
    List<TransactionModel> list, {
    required bool canViewAllTransactions,
  }) {
    if (_items.isEmpty && _loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (list.isEmpty) {
      return Center(
        child: Text(
          canViewAllTransactions && _selectedUserId == null
              ? 'لا توجد معاملات بعد'
              : canViewAllTransactions
                  ? 'لا توجد معاملات لهذا المستخدم'
                  : 'لا توجد معاملات تخصك حاليا',
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
        final isAutoSettlement = tx.createdByUserId == 'system:settlement';
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
                        if (isAutoSettlement) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'تسوية تلقائية',
                              style: TextStyle(
                                color: AppColors.info,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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

class _MonthlyMetrics {
  final double totalAmount;
  final double incoming;
  final double outgoing;
  final int count;

  const _MonthlyMetrics({
    this.totalAmount = 0,
    this.incoming = 0,
    this.outgoing = 0,
    this.count = 0,
  });

  _MonthlyMetrics copyWith({
    double? totalAmount,
    double? incoming,
    double? outgoing,
    int? count,
  }) {
    return _MonthlyMetrics(
      totalAmount: totalAmount ?? this.totalAmount,
      incoming: incoming ?? this.incoming,
      outgoing: outgoing ?? this.outgoing,
      count: count ?? this.count,
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

String _formatMonthKey(String monthKey) {
  final parts = monthKey.split('-');
  if (parts.length != 2) return monthKey;
  return '${parts[1]}/${parts[0]}';
}

Widget _headerMetaChip({
  required IconData icon,
  required String text,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: const Color(0xFF3A3A64)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
