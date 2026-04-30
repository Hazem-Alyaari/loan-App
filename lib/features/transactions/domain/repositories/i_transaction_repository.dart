import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/transactions/domain/models/settlement_proposal.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Contract for transaction operations.
abstract class ITransactionRepository {
  /// Create a new transaction in a group.
  Future<void> createTransaction(TransactionModel transaction);

  /// Watch all transactions in a group, ordered by creation date.
  Stream<List<TransactionModel>> watchGroupTransactions(String groupId);

  /// Fetch transactions page for pagination.
  Future<
      ({
        List<TransactionModel> items,
        QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
        bool hasMore,
      })> fetchGroupTransactionsPage(
    String groupId, {
    QueryDocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 5,
  });

  /// Fetch approved transactions for one member in a group.
  Future<List<TransactionModel>> fetchMemberApprovedTransactions(
    String groupId, {
    required String memberUserId,
  });

  Future<int> createSettlementProposals(String groupId);

  Stream<List<SettlementProposal>> watchGroupSettlementProposals(
    String groupId, {
    String? userId,
    bool includeResolved = false,
  });

  Future<void> respondToSettlementProposal({
    required String groupId,
    required String proposalId,
    required String userId,
    required bool approve,
  });

  /// Watch a single transaction.
  Stream<TransactionModel> watchTransaction(String groupId, String transactionId);

  /// Update a transaction's status (approve/reject/cancel).
  Future<void> updateTransactionStatus({
    required String groupId,
    required String transactionId,
    required TransactionStatus status,
  });

  /// Delete a transaction (only if still pending).
  Future<void> deleteTransaction(String groupId, String transactionId);
}
