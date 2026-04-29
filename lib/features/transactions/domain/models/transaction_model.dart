import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/utils/timestamp_converter.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String groupId,
    required String createdByUserId,
    required TransactionType type,
    @Default(TransactionStatus.pending) TransactionStatus status,
    required String creditorUserId,
    required String debtorUserId,
    required double amount,
    required String currency,
    @Default('') String note,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? approvedAt,
    @NullableTimestampConverter() DateTime? rejectedAt,
    /// Denormalized names for display
    String? creditorName,
    String? debtorName,
    String? createdByName,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return TransactionModel.fromJson({'id': doc.id, ...data});
  }
}
