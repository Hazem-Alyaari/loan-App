// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      status:
          $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.pending,
      creditorUserId: json['creditorUserId'] as String,
      debtorUserId: json['debtorUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      note: json['note'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      approvedAt: const NullableTimestampConverter().fromJson(
        json['approvedAt'] as Timestamp?,
      ),
      rejectedAt: const NullableTimestampConverter().fromJson(
        json['rejectedAt'] as Timestamp?,
      ),
      creditorName: json['creditorName'] as String?,
      debtorName: json['debtorName'] as String?,
      createdByName: json['createdByName'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(
  _TransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'createdByUserId': instance.createdByUserId,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'status': _$TransactionStatusEnumMap[instance.status]!,
  'creditorUserId': instance.creditorUserId,
  'debtorUserId': instance.debtorUserId,
  'amount': instance.amount,
  'currency': instance.currency,
  'note': instance.note,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'approvedAt': const NullableTimestampConverter().toJson(instance.approvedAt),
  'rejectedAt': const NullableTimestampConverter().toJson(instance.rejectedAt),
  'creditorName': instance.creditorName,
  'debtorName': instance.debtorName,
  'createdByName': instance.createdByName,
};

const _$TransactionTypeEnumMap = {
  TransactionType.loan: 'loan',
  TransactionType.repayment: 'repayment',
  TransactionType.correction: 'correction',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.approved: 'approved',
  TransactionStatus.rejected: 'rejected',
  TransactionStatus.cancelled: 'cancelled',
};
