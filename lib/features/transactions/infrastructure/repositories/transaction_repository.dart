import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/notifications/domain/models/app_notification.dart';
import 'package:loan/features/transactions/domain/models/settlement_proposal.dart';
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
  CollectionReference<Map<String, dynamic>> _settlementRef(String groupId) =>
      _groupDoc(groupId).collection('settlement_proposals');

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
  Future<List<TransactionModel>> fetchMemberApprovedTransactions(
    String groupId, {
    required String memberUserId,
  }) async {
    final asCreditorQuery = _txRef(groupId)
        .where('status', isEqualTo: TransactionStatus.approved.name)
        .where('creditorUserId', isEqualTo: memberUserId);
    final asDebtorQuery = _txRef(groupId)
        .where('status', isEqualTo: TransactionStatus.approved.name)
        .where('debtorUserId', isEqualTo: memberUserId);

    final snapshots = await Future.wait([asCreditorQuery.get(), asDebtorQuery.get()]);
    final merged = <String, TransactionModel>{};
    for (final snapshot in snapshots) {
      for (final doc in snapshot.docs) {
        merged[doc.id] = TransactionModel.fromFirestore(doc);
      }
    }
    final list = merged.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<int> createSettlementProposals(String groupId) async {
    final txSnapshot = await _txRef(groupId)
        .where('status', isEqualTo: TransactionStatus.approved.name)
        .get();
    final approved = txSnapshot.docs.map(TransactionModel.fromFirestore).toList();
    final debtGraph = <String, Map<String, double>>{};
    for (final tx in approved) {
      final debtorMap = debtGraph[tx.debtorUserId] ?? <String, double>{};
      debtorMap[tx.creditorUserId] =
          (debtorMap[tx.creditorUserId] ?? 0) + tx.amount;
      debtGraph[tx.debtorUserId] = debtorMap;
    }
    _netDebtGraph(debtGraph);

    final users = debtGraph.keys.toList();
    final existingPending = await _settlementRef(groupId)
        .where('finalStatus', isEqualTo: 'pending')
        .get();
    final existingKeys = existingPending.docs
        .map((doc) => (doc.data()['participants'] as List<dynamic>? ?? const [])
            .cast<String>()
          ..sort())
        .map((list) => list.join('|'))
        .toSet();

    var created = 0;
    final now = DateTime.now();
    for (final a in users) {
      final aTo = debtGraph[a] ?? const <String, double>{};
      for (final bEntry in aTo.entries) {
        final b = bEntry.key;
        final ab = bEntry.value;
        if (ab <= 0) continue;
        final bTo = debtGraph[b] ?? const <String, double>{};
        for (final cEntry in bTo.entries) {
          final c = cEntry.key;
          final bc = cEntry.value;
          if (bc <= 0 || c == a || c == b) continue;
          final cToA = (debtGraph[c] ?? const <String, double>{})[a] ?? 0;
          if (cToA <= 0) continue;

          final participants = [a, b, c]..sort();
          final signature = participants.join('|');
          if (existingKeys.contains(signature)) continue;

          final settleAmount = [ab, bc, cToA].reduce((x, y) => x < y ? x : y);
          if (settleAmount <= 0) continue;
          final proposalRef = _settlementRef(groupId).doc();
          final approvals = {for (final userId in participants) userId: 'pending'};
          final proposal = SettlementProposal(
            id: proposalRef.id,
            groupId: groupId,
            participants: participants,
            path: [
              SettlementEdge(debtorUserId: a, creditorUserId: b, amount: ab),
              SettlementEdge(debtorUserId: b, creditorUserId: c, amount: bc),
              SettlementEdge(debtorUserId: c, creditorUserId: a, amount: cToA),
            ],
            settlementAmount: settleAmount,
            approvals: approvals,
            finalStatus: 'pending',
            createdAt: now,
            expiresAt: now.add(const Duration(hours: 12)),
          );

          final groupSnap = await _groupDoc(groupId).get();
          final memberIds = (groupSnap.data()?['memberIds'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              <String>[];

          final batch = _firestore.batch();
          batch.set(proposalRef, proposal.toJson());
          for (final userId in memberIds) {
            final isParticipant = participants.contains(userId);
            final notif = AppNotification(
              id: 'settlement_${proposal.id}_$userId',
              userId: userId,
              groupId: groupId,
              type: NotificationType.approvalRequest,
              title: 'اقتراح تصفية ديون',
              message: isParticipant
                  ? 'تم اكتشاف تسوية ممكنة بقيمة ${settleAmount.toStringAsFixed(2)}. صلاحية الاقتراح 12 ساعة. راجع تبويب التحليل ووافق للتنفيذ.'
                  : 'تم إنشاء اقتراح تصفية ديون في المجموعة. يمكنك متابعته من تبويب التحليل (صلاحية 12 ساعة).',
              createdAt: now,
            );
            batch.set(_userNotifRef(userId, notif.id), notif.toJson());
          }
          await batch.commit();
          existingKeys.add(signature);
          created++;
        }
      }
    }
    return created;
  }

  void _netDebtGraph(Map<String, Map<String, double>> graph) {
    final users = graph.keys.toList();
    for (final a in users) {
      final aMap = graph[a] ?? <String, double>{};
      final bKeys = aMap.keys.toList();
      for (final b in bKeys) {
        final ab = (graph[a]?[b] ?? 0);
        final ba = (graph[b]?[a] ?? 0);
        if (ab <= 0 || ba <= 0) continue;
        final minVal = ab < ba ? ab : ba;
        final newAb = ab - minVal;
        final newBa = ba - minVal;
        if (newAb <= 0.0001) {
          graph[a]?.remove(b);
        } else {
          graph[a]![b] = newAb;
        }
        if (newBa <= 0.0001) {
          graph[b]?.remove(a);
        } else {
          graph[b]![a] = newBa;
        }
      }
      if ((graph[a] ?? const {}).isEmpty) {
        graph.remove(a);
      }
    }
  }

  @override
  Stream<List<SettlementProposal>> watchGroupSettlementProposals(
    String groupId, {
    String? userId,
    bool includeResolved = false,
  }) {
    // Avoid composite-index requirements by using a single optional Firestore
    // filter, then applying remaining filters/sorting locally.
    Query<Map<String, dynamic>> query = _settlementRef(groupId);
    if (userId != null) {
      query = query.where('participants', arrayContains: userId);
    } else if (!includeResolved) {
      query = query.where('finalStatus', isEqualTo: 'pending');
    }

    return query.snapshots().asyncMap((snapshot) async {
      await _expirePendingSettlementProposals(snapshot);
      final now = DateTime.now();
      var items = snapshot.docs.map(SettlementProposal.fromFirestore).toList();
      if (!includeResolved) {
        items = items
            .where(
              (p) =>
                  p.finalStatus == 'pending' && !p.expiresAt.isBefore(now),
            )
            .toList();
      }
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  Future<void> _expirePendingSettlementProposals(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final now = DateTime.now();
    final batch = _firestore.batch();
    var hasWrites = false;
    for (final doc in snapshot.docs) {
      final p = SettlementProposal.fromFirestore(doc);
      if (p.finalStatus == 'pending' && p.expiresAt.isBefore(now)) {
        batch.update(doc.reference, {
          'finalStatus': 'expired',
          'resolvedAt': FieldValue.serverTimestamp(),
        });
        hasWrites = true;
      }
    }
    if (hasWrites) {
      await batch.commit();
    }
  }

  @override
  Future<void> respondToSettlementProposal({
    required String groupId,
    required String proposalId,
    required String userId,
    required bool approve,
  }) async {
    final proposalRef = _settlementRef(groupId).doc(proposalId);
    final groupDoc = await _groupDoc(groupId).get();
    final groupCurrency =
        (groupDoc.data()?['currencyCode'] as String?) ?? 'USD';
    final membersSnapshot = await _groupDoc(groupId).collection('members').get();
    final memberNameById = <String, String>{
      for (final doc in membersSnapshot.docs)
        doc.id: ((doc.data()['userName'] as String?) ?? doc.id),
    };
    final doc = await proposalRef.get();
    if (!doc.exists) throw Exception('الاقتراح غير موجود');
    final proposal = SettlementProposal.fromFirestore(doc);
    if (!proposal.isPending) return;
    if (!proposal.participants.contains(userId)) {
      throw Exception('غير مصرح لك بالتصويت على هذا الاقتراح');
    }
    if (proposal.expiresAt.isBefore(DateTime.now())) {
      await proposalRef.update({
        'finalStatus': 'expired',
        'resolvedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    final batch = _firestore.batch();
    final updatedApprovals = Map<String, String>.from(proposal.approvals)
      ..[userId] = approve ? 'approved' : 'rejected';
    batch.update(proposalRef, {'approvals': updatedApprovals});

    if (!approve) {
      batch.update(proposalRef, {
        'finalStatus': 'rejected',
        'resolvedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
      return;
    }

    final allApproved =
        proposal.participants.every((id) => updatedApprovals[id] == 'approved');
    if (!allApproved) {
      await batch.commit();
      return;
    }

    for (final edge in proposal.path) {
      final txRef = _txRef(groupId).doc();
      final tx = TransactionModel(
        id: txRef.id,
        groupId: groupId,
        createdByUserId: 'system:settlement',
        type: TransactionType.correction,
        status: TransactionStatus.approved,
        creditorUserId: edge.debtorUserId,
        debtorUserId: edge.creditorUserId,
        amount: proposal.settlementAmount,
        currency: groupCurrency,
        note: 'تسوية ديون تلقائية',
        createdAt: DateTime.now(),
        approvedAt: DateTime.now(),
        creditorName: memberNameById[edge.debtorUserId],
        debtorName: memberNameById[edge.creditorUserId],
        createdByName: 'النظام',
      );
      batch.set(txRef, tx.toJson());
      batch.update(_groupDoc(groupId), {
        'balances.${edge.debtorUserId}':
            FieldValue.increment(proposal.settlementAmount),
        'balances.${edge.creditorUserId}':
            FieldValue.increment(-proposal.settlementAmount),
      });
    }

    batch.update(proposalRef, {
      'finalStatus': 'approved',
      'resolvedAt': FieldValue.serverTimestamp(),
    });
    for (final participant in proposal.participants) {
      final notif = AppNotification(
        id: 'settlement_done_${proposal.id}_$participant',
        userId: participant,
        groupId: groupId,
        type: NotificationType.balanceUpdated,
        title: 'تم تنفيذ التسوية بنجاح',
        message:
            'اكتملت الموافقات وتم تنفيذ تسوية بقيمة ${proposal.settlementAmount.toStringAsFixed(2)}.',
        createdAt: DateTime.now(),
      );
      batch.set(_userNotifRef(participant, notif.id), notif.toJson());
    }
    await batch.commit();
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
    final wasApproved = tx.status == TransactionStatus.approved;
    final isNowApproved = status == TransactionStatus.approved;

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

    // Keep persisted group balances synchronized with approval state changes.
    // Approved -> apply amount (creditor +amount, debtor -amount)
    // Reverted from approved -> rollback amount.
    if (!wasApproved && isNowApproved) {
      batch.update(_groupDoc(groupId), {
        'balances.${tx.creditorUserId}': FieldValue.increment(tx.amount),
        'balances.${tx.debtorUserId}': FieldValue.increment(-tx.amount),
      });
    } else if (wasApproved && !isNowApproved) {
      batch.update(_groupDoc(groupId), {
        'balances.${tx.creditorUserId}': FieldValue.increment(-tx.amount),
        'balances.${tx.debtorUserId}': FieldValue.increment(tx.amount),
      });
    }

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

    if (!wasApproved && isNowApproved) {
      // Privacy: notify only users involved in this transaction.
      final participantIds = <String>{
        tx.createdByUserId,
        tx.creditorUserId,
        tx.debtorUserId,
      };
      for (final userId in participantIds) {
        final notif = AppNotification(
          id: 'tx_${tx.id}_balance_updated_$userId',
          userId: userId,
          groupId: tx.groupId,
          transactionId: tx.id,
          type: NotificationType.balanceUpdated,
          title: 'تم تنفيذ العملية بنجاح',
          message:
              'تم اعتماد المعاملة وتحديث الرصيد تلقائيا بمبلغ ${tx.amount.toStringAsFixed(2)} ${tx.currency}.',
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
