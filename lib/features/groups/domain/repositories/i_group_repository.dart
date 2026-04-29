import 'package:loan/features/groups/domain/models/group_model.dart';
import 'package:loan/features/groups/domain/models/group_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Watch current user's membership record in a group.
  Stream<GroupMember?> watchMember(String groupId, String userId);

  /// Fetch members page for pagination.
  Future<
      ({
        List<GroupMember> items,
        QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
        bool hasMore,
      })> fetchGroupMembersPage(
    String groupId, {
    QueryDocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 5,
  });

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
