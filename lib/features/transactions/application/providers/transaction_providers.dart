import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';
import 'package:loan/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:loan/features/transactions/infrastructure/repositories/transaction_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------
final transactionRepositoryProvider = Provider<ITransactionRepository>((ref) {
  return TransactionRepository(firestore: ref.watch(firestoreProvider));
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
}
