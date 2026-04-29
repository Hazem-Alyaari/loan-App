import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/utils/timestamp_converter.dart';

part 'transaction_approval.freezed.dart';
part 'transaction_approval.g.dart';

@freezed
abstract class TransactionApproval with _$TransactionApproval {
  const factory TransactionApproval({
    required String id,
    required String transactionId,
    required String userId,
    @Default(ApprovalStatus.pending) ApprovalStatus status,
    @NullableTimestampConverter() DateTime? respondedAt,
    @Default('') String comment,
  }) = _TransactionApproval;

  factory TransactionApproval.fromJson(Map<String, dynamic> json) =>
      _$TransactionApprovalFromJson(json);

  factory TransactionApproval.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return TransactionApproval.fromJson({'id': doc.id, ...data});
  }
}
