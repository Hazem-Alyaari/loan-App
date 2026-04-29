// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  transactionId: json['transactionId'] as String?,
  actorUserId: json['actorUserId'] as String,
  action: json['action'] as String,
  detailsJson: json['detailsJson'] as Map<String, dynamic>? ?? const {},
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'transactionId': instance.transactionId,
  'actorUserId': instance.actorUserId,
  'action': instance.action,
  'detailsJson': instance.detailsJson,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};
