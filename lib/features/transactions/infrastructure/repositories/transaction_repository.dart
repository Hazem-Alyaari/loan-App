import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/notifications/domain/models/app_notification.dart';
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

  DocumentReference<Map<String, dynamic>> _userNotifRef(
    String userId,
    String notificationId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId);

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    final docRef = _txRef(transaction.groupId).doc(transaction.id);
    final batch = _firestore.batch();
    batch.set(docRef, transaction.toJson());

    if (transaction.debtorUserId != transaction.createdByUserId) {
      final pendingNotif = AppNotification(
        id: 'tx_${transaction.id}_approval_${transaction.debtorUserId}',
        userId: transaction.debtorUserId,
        groupId: transaction.groupId,
        transactionId: transaction.id,
        type: NotificationType.approvalRequest,
        title: 'معاملة جديدة بانتظار موافقتك',
        message:
            'قام ${transaction.createdByName ?? transaction.creditorName ?? 'أحد الأعضاء'} بإضافة معاملة بمبلغ ${transaction.amount.toStringAsFixed(2)} ${transaction.currency}.',
        createdAt: DateTime.now(),
      );

      batch.set(
        _userNotifRef(transaction.debtorUserId, pendingNotif.id),
        pendingNotif.toJson(),
      );
    }

    await batch.commit();
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
  Future<
      ({
        List<TransactionModel> items,
        QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
        bool hasMore,
      })> fetchGroupTransactionsPage(
    String groupId, {
    QueryDocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 5,
  }) async {
    Query<Map<String, dynamic>> query =
        _txRef(groupId).orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final items =
        snapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList();
    return (
      items: items,
      lastDoc: snapshot.docs.isEmpty ? null : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
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
    final txDoc = await _txRef(groupId).doc(transactionId).get();
    if (!txDoc.exists) {
      throw Exception('المعاملة غير موجودة');
    }
    final tx = TransactionModel.fromFirestore(txDoc);

    final updates = <String, dynamic>{
      'status': status.name,
    };

    if (status == TransactionStatus.approved) {
      updates['approvedAt'] = FieldValue.serverTimestamp();
    } else if (status == TransactionStatus.rejected) {
      updates['rejectedAt'] = FieldValue.serverTimestamp();
    }

    final batch = _firestore.batch();
    batch.update(_txRef(groupId).doc(transactionId), updates);

    if (status == TransactionStatus.approved ||
        status == TransactionStatus.rejected) {
      final type = status == TransactionStatus.approved
          ? NotificationType.transactionApproved
          : NotificationType.transactionRejected;
      final title = status == TransactionStatus.approved
          ? 'تمت الموافقة على المعاملة'
          : 'تم رفض المعاملة';
      final message = status == TransactionStatus.approved
          ? 'وافق ${tx.debtorName ?? 'المدين'} على معاملتك بمبلغ ${tx.amount.toStringAsFixed(2)} ${tx.currency}.'
          : 'رفض ${tx.debtorName ?? 'المدين'} معاملتك بمبلغ ${tx.amount.toStringAsFixed(2)} ${tx.currency}.';

      final notifyUserIds = <String>{
        tx.createdByUserId,
        tx.creditorUserId,
      }..remove(tx.debtorUserId);

      for (final userId in notifyUserIds) {
        final notif = AppNotification(
          id: 'tx_${tx.id}_${status.name}_$userId',
          userId: userId,
          groupId: tx.groupId,
          transactionId: tx.id,
          type: type,
          title: title,
          message: message,
          createdAt: DateTime.now(),
        );
        batch.set(_userNotifRef(userId, notif.id), notif.toJson());
      }
    }

    await batch.commit();
  }

  @override
  Future<void> deleteTransaction(String groupId, String transactionId) async {
    await _txRef(groupId).doc(transactionId).delete();
  }
}
