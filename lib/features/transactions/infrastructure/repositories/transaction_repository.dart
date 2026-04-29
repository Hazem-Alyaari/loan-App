import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/transactions/domain/models/transaction_model.dart';
import 'package:loan/features/transactions/domain/repositories/i_transaction_repository.dart';

class TransactionRepository implements ITransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _groupDoc(String groupId) =>
      _firestore.collection('groups').doc(groupId);

  CollectionReference<Map<String, dynamic>> _txRef(String groupId) =>
      _groupDoc(groupId).collection('transactions');

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    final docRef = _txRef(transaction.groupId).doc(transaction.id);
    await docRef.set(transaction.toJson());
  }

  @override
  Stream<List<TransactionModel>> watchGroupTransactions(String groupId) {
    return _txRef(groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<TransactionModel> watchTransaction(
      String groupId, String transactionId) {
    return _txRef(groupId).doc(transactionId).snapshots().map(
          (doc) => TransactionModel.fromFirestore(doc),
        );
  }

  @override
  Future<void> updateTransactionStatus({
    required String groupId,
    required String transactionId,
    required TransactionStatus status,
  }) async {
    final updates = <String, dynamic>{
      'status': status.name,
    };

    if (status == TransactionStatus.approved) {
      updates['approvedAt'] = FieldValue.serverTimestamp();
    } else if (status == TransactionStatus.rejected) {
      updates['rejectedAt'] = FieldValue.serverTimestamp();
    }

    await _txRef(groupId).doc(transactionId).update(updates);
  }

  @override
  Future<void> deleteTransaction(String groupId, String transactionId) async {
    await _txRef(groupId).doc(transactionId).delete();
  }
}
