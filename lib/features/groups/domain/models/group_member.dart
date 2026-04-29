import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/core/utils/timestamp_converter.dart';

part 'group_member.freezed.dart';
part 'group_member.g.dart';

@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String id,
    required String groupId,
    required String userId,
    required MemberRole role,
    @Default(MemberStatus.active) MemberStatus status,
    @TimestampConverter() required DateTime joinedAt,
    /// Denormalized user info for display without extra reads.
    String? userName,
    String? userEmail,
    String? userPhone,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  factory GroupMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return GroupMember.fromJson({'id': doc.id, ...data});
  }
}
