import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/groups/domain/models/group_model.dart';
import 'package:loan/features/groups/domain/models/group_member.dart';
import 'package:loan/features/groups/domain/repositories/i_group_repository.dart';

class GroupRepository implements IGroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  @override
  Future<GroupModel> createGroup({
    required String name,
    required String currencyCode,
    required String creatorUserId,
    required String creatorName,
    required String creatorEmail,
  }) async {
    final docRef = _groupsRef.doc();
    final now = DateTime.now();

    final group = GroupModel(
      id: docRef.id,
      name: name,
      createdByUserId: creatorUserId,
      createdAt: now,
      currencyCode: currencyCode,
      memberIds: [creatorUserId],
      balances: {creatorUserId: 0.0},
    );

    final member = GroupMember(
      id: creatorUserId,
      groupId: docRef.id,
      userId: creatorUserId,
      role: MemberRole.owner,
      status: MemberStatus.active,
      joinedAt: now,
      userName: creatorName,
      userEmail: creatorEmail,
    );

    final batch = _firestore.batch();
    batch.set(docRef, group.toJson());
    batch.set(
      docRef.collection('members').doc(creatorUserId),
      member.toJson(),
    );
    await batch.commit();

    return group;
  }

  @override
  Stream<List<GroupModel>> watchUserGroups(String userId) {
    return _groupsRef
        .where('memberIds', arrayContains: userId)
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      final groups =
          snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();
      groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return groups;
    });
  }

  @override
  Stream<GroupModel> watchGroup(String groupId) {
    return _groupsRef.doc(groupId).snapshots().map(
          (doc) => GroupModel.fromFirestore(doc),
        );
  }

  @override
  Stream<List<GroupMember>> watchGroupMembers(String groupId) {
    return _groupsRef
        .doc(groupId)
        .collection('members')
        .where('status', isEqualTo: MemberStatus.active.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupMember.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> addMember({
    required String groupId,
    required String userId,
    required String userName,
    required String userEmail,
    String? userPhone,
  }) async {
    final now = DateTime.now();
    final member = GroupMember(
      id: userId,
      groupId: groupId,
      userId: userId,
      role: MemberRole.member,
      status: MemberStatus.active,
      joinedAt: now,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
    );

    final batch = _firestore.batch();

    // Add member sub-document
    batch.set(
      _groupsRef.doc(groupId).collection('members').doc(userId),
      member.toJson(),
    );

    // Add userId to denormalized memberIds array
    batch.update(_groupsRef.doc(groupId), {
      'memberIds': FieldValue.arrayUnion([userId]),
      'balances.$userId': 0.0,
    });

    await batch.commit();
  }

  @override
  Future<void> removeMember(String groupId, String userId) async {
    final batch = _firestore.batch();

    batch.update(
      _groupsRef.doc(groupId).collection('members').doc(userId),
      {'status': MemberStatus.removed.name},
    );

    batch.update(_groupsRef.doc(groupId), {
      'memberIds': FieldValue.arrayRemove([userId]),
    });

    await batch.commit();
  }

  @override
  Future<void> toggleArchive(String groupId, bool isArchived) async {
    await _groupsRef.doc(groupId).update({'isArchived': isArchived});
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    // In production, use a Cloud Function to recursively delete subcollections.
    await _groupsRef.doc(groupId).delete();
  }

}
