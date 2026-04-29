// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => _GroupMember(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  userId: json['userId'] as String,
  role: $enumDecode(_$MemberRoleEnumMap, json['role']),
  status:
      $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
      MemberStatus.active,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Timestamp),
  userName: json['userName'] as String?,
  userEmail: json['userEmail'] as String?,
  userPhone: json['userPhone'] as String?,
);

Map<String, dynamic> _$GroupMemberToJson(_GroupMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'role': _$MemberRoleEnumMap[instance.role]!,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
    };

const _$MemberRoleEnumMap = {
  MemberRole.owner: 'owner',
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
};

const _$MemberStatusEnumMap = {
  MemberStatus.invited: 'invited',
  MemberStatus.active: 'active',
  MemberStatus.removed: 'removed',
};
