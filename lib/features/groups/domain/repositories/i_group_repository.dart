import 'package:loan/features/groups/domain/models/group_model.dart';
import 'package:loan/features/groups/domain/models/group_member.dart';

/// Contract for group management operations.
abstract class IGroupRepository {
  /// Create a new group and add the creator as the owner.
  Future<GroupModel> createGroup({
    required String name,
    required String currencyCode,
    required String creatorUserId,
    required String creatorName,
    required String creatorEmail,
  });

  /// Watch all groups the current user belongs to.
  Stream<List<GroupModel>> watchUserGroups(String userId);

  /// Watch a single group by ID.
  Stream<GroupModel> watchGroup(String groupId);

  /// Watch members of a group.
  Stream<List<GroupMember>> watchGroupMembers(String groupId);

  /// Add a member to a group (by email or user ID).
  Future<void> addMember({
    required String groupId,
    required String userId,
    required String userName,
    required String userEmail,
    String? userPhone,
  });

  /// Remove a member from a group.
  Future<void> removeMember(String groupId, String userId);

  /// Archive/unarchive a group.
  Future<void> toggleArchive(String groupId, bool isArchived);

  /// Delete a group entirely.
  Future<void> deleteGroup(String groupId);
}
