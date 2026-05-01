import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/locale/app_locale.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/transactions/domain/models/settlement_proposal.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';
import 'package:loan/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:loan/features/transactions/infrastructure/repositories/transaction_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------
final transactionRepositoryProvider = Provider<ITransactionRepository>((ref) {
  final isArabic = ref.watch(appLocaleProvider).languageCode == 'ar';
  return TransactionRepository(
    firestore: ref.watch(firestoreProvider),
    isArabic: isArabic,
  );
});

// ---------------------------------------------------------------------------
// Group transactions stream
// ---------------------------------------------------------------------------
final groupTransactionsProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, groupId) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchGroupTransactions(groupId);
});

final memberApprovedTransactionsProvider = FutureProvider.family<
    List<TransactionModel>, ({String groupId, String userId})>((ref, params) {
  return ref.watch(transactionRepositoryProvider).fetchMemberApprovedTransactions(
        params.groupId,
        memberUserId: params.userId,
      );
});

final groupSettlementProposalsProvider =
    StreamProvider.family<List<SettlementProposal>, String>((ref, groupId) {
  return ref.watch(transactionRepositoryProvider).watchGroupSettlementProposals(
        groupId,
      );
});

// ---------------------------------------------------------------------------
// Single transaction stream
// ---------------------------------------------------------------------------
final transactionDetailProvider = StreamProvider.family<TransactionModel,
    ({String groupId, String transactionId})>((ref, params) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchTransaction(params.groupId, params.transactionId);
});

// ---------------------------------------------------------------------------
// Transaction controller
// ---------------------------------------------------------------------------
final transactionControllerProvider =
    AsyncNotifierProvider<TransactionController, void>(
        TransactionController.new);

class TransactionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  ITransactionRepository get _repo =>
      ref.read(transactionRepositoryProvider);

  Future<void> createTransaction(TransactionModel transaction) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.createTransaction(transaction));
  }

  Future<void> approveTransaction(String groupId, String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateTransactionStatus(
        groupId: groupId,
        transactionId: transactionId,
        status: TransactionStatus.approved,
      ),
    );
  }

  Future<void> rejectTransaction(String groupId, String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateTransactionStatus(
        groupId: groupId,
        transactionId: transactionId,
        status: TransactionStatus.rejected,
      ),
    );
  }

  Future<void> cancelTransaction(String groupId, String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateTransactionStatus(
        groupId: groupId,
        transactionId: transactionId,
        status: TransactionStatus.cancelled,
      ),
    );
  }

  Future<int> createSettlementProposals(String groupId) async {
    state = const AsyncLoading();
    int created = 0;
    state = await AsyncValue.guard(() async {
      created = await _repo.createSettlementProposals(groupId);
    });
    return created;
  }

  Future<void> respondToSettlementProposal({
    required String groupId,
    required String proposalId,
    required bool approve,
  }) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.respondToSettlementProposal(
        groupId: groupId,
        proposalId: proposalId,
        userId: uid,
        approve: approve,
      ),
    );
  }
}
