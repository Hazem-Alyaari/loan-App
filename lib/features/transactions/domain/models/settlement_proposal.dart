import 'package:cloud_firestore/cloud_firestore.dart';

class SettlementEdge {
  final String debtorUserId;
  final String creditorUserId;
  final double amount;

  const SettlementEdge({
    required this.debtorUserId,
    required this.creditorUserId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'debtorUserId': debtorUserId,
        'creditorUserId': creditorUserId,
        'amount': amount,
      };

  factory SettlementEdge.fromJson(Map<String, dynamic> json) {
    return SettlementEdge(
      debtorUserId: json['debtorUserId'] as String,
      creditorUserId: json['creditorUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class SettlementProposal {
  final String id;
  final String groupId;
  final List<String> participants;
  final List<SettlementEdge> path;
  final double settlementAmount;
  final Map<String, String> approvals;
  final String finalStatus; // pending / approved / rejected / expired
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? resolvedAt;

  const SettlementProposal({
    required this.id,
    required this.groupId,
    required this.participants,
    required this.path,
    required this.settlementAmount,
    required this.approvals,
    required this.finalStatus,
    required this.createdAt,
    required this.expiresAt,
    this.resolvedAt,
  });

  bool get isPending => finalStatus == 'pending';

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'participants': participants,
        'path': path.map((edge) => edge.toJson()).toList(),
        'settlementAmount': settlementAmount,
        'approvals': approvals,
        'finalStatus': finalStatus,
        'createdAt': Timestamp.fromDate(createdAt),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'resolvedAt': resolvedAt == null ? null : Timestamp.fromDate(resolvedAt!),
      };

  factory SettlementProposal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    final pathRaw = (data['path'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final approvalsRaw = (data['approvals'] as Map<String, dynamic>? ?? const {})
        .map((key, value) => MapEntry(key, value.toString()));
    return SettlementProposal(
      id: doc.id,
      groupId: data['groupId'] as String,
      participants:
          (data['participants'] as List<dynamic>? ?? const []).cast<String>(),
      path: pathRaw.map(SettlementEdge.fromJson).toList(),
      settlementAmount: (data['settlementAmount'] as num).toDouble(),
      approvals: approvalsRaw,
      finalStatus: (data['finalStatus'] as String?) ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
    );
  }
}
