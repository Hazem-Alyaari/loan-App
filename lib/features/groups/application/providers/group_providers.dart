import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/groups/domain/models/group_model.dart';
import 'package:loan/features/groups/domain/models/group_member.dart';
import 'package:loan/features/groups/domain/repositories/i_group_repository.dart';
import 'package:loan/features/groups/infrastructure/repositories/group_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------
final groupRepositoryProvider = Provider<IGroupRepository>((ref) {
  return GroupRepository(firestore: ref.watch(firestoreProvider));
});

// ---------------------------------------------------------------------------
// User groups stream
// ---------------------------------------------------------------------------
final userGroupsProvider = StreamProvider<List<GroupModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(groupRepositoryProvider).watchUserGroups(uid);
});

// ---------------------------------------------------------------------------
// Single group stream (by ID)
// ---------------------------------------------------------------------------
final groupDetailProvider =
    StreamProvider.family<GroupModel, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).watchGroup(groupId);
});

// ---------------------------------------------------------------------------
// Group members stream
// ---------------------------------------------------------------------------
final groupMembersProvider =
    StreamProvider.family<List<GroupMember>, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).watchGroupMembers(groupId);
});

final currentGroupMemberProvider =
    StreamProvider.family<GroupMember?, String>((ref, groupId) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(groupRepositoryProvider).watchMember(groupId, uid);
});

// ---------------------------------------------------------------------------
// Group controller (create, add member, etc.)
// ---------------------------------------------------------------------------
final groupControllerProvider =
    AsyncNotifierProvider<GroupController, void>(GroupController.new);

class GroupController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  IGroupRepository get _repo => ref.read(groupRepositoryProvider);

  Future<GroupModel?> createGroup({
    required String name,
    required String currencyCode,
  }) async {
    state = const AsyncLoading();
    GroupModel? result;
    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('المستخدم غير مسجل الدخول');

      final profile =
          await ref.read(authRepositoryProvider).getUserProfile(user.uid);

      result = await _repo.createGroup(
        name: name,
        currencyCode: currencyCode,
        creatorUserId: user.uid,
        creatorName: profile?.fullName ?? 'مستخدم',
        creatorEmail: profile?.email ?? '',
      );
    });
    return result;
  }

  Future<void> addMember({
    required String groupId,
    required String userId,
    required String userName,
    required String userEmail,
    String? userPhone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.addMember(
        groupId: groupId,
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        userPhone: userPhone,
      ),
    );
  }

  Future<void> addMemberByPhone({
    required String groupId,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final appUser =
            await ref.read(authRepositoryProvider).ensurePhoneUserAccount(
                  fullName: fullName,
                  phoneNumber: phoneNumber,
                  password: '12345678',
                );

        await _repo.addMember(
          groupId: groupId,
          userId: appUser.id,
          userName: appUser.fullName,
          userEmail: _displayEmail(appUser.email),
          userPhone: appUser.phoneNumber,
        );
      },
    );
  }

  Future<void> removeMember(String groupId, String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.removeMember(groupId, userId));
  }

  Future<void> toggleArchive(String groupId, bool isArchived) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _repo.toggleArchive(groupId, isArchived));
  }

  String _displayEmail(String email) {
    return email.endsWith('@loantrack.local') ? '' : email;
  }
}
