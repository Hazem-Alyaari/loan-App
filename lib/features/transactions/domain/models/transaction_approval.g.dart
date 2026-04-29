// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionApproval _$TransactionApprovalFromJson(Map<String, dynamic> json) =>
    _TransactionApproval(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      userId: json['userId'] as String,
      status:
          $enumDecodeNullable(_$ApprovalStatusEnumMap, json['status']) ??
          ApprovalStatus.pending,
      respondedAt: const NullableTimestampConverter().fromJson(
        json['respondedAt'] as Timestamp?,
      ),
      comment: json['comment'] as String? ?? '',
    );

Map<String, dynamic> _$TransactionApprovalToJson(
  _TransactionApproval instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionId': instance.transactionId,
  'userId': instance.userId,
  'status': _$ApprovalStatusEnumMap[instance.status]!,
  'respondedAt': const NullableTimestampConverter().toJson(
    instance.respondedAt,
  ),
  'comment': instance.comment,
};

const _$ApprovalStatusEnumMap = {
  ApprovalStatus.pending: 'pending',
  ApprovalStatus.approved: 'approved',
  ApprovalStatus.rejected: 'rejected',
};
