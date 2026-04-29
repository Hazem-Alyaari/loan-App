import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/utils/timestamp_converter.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String groupId,
    String? transactionId,
    required String actorUserId,
    required String action,
    @Default({}) Map<String, dynamic> detailsJson,
    @TimestampConverter() required DateTime createdAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);

  factory AuditLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return AuditLog.fromJson({'id': doc.id, ...data});
  }
}
