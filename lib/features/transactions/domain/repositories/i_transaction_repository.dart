import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';

/// Contract for transaction operations.
abstract class ITransactionRepository {
  /// Create a new transaction in a group.
  Future<void> createTransaction(TransactionModel transaction);

  /// Watch all transactions in a group, ordered by creation date.
  Stream<List<TransactionModel>> watchGroupTransactions(String groupId);

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
