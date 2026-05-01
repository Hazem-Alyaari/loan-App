import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/core/locale/app_locale.dart';
import 'package:loan/features/auth/domain/models/app_user.dart';
import 'package:loan/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:loan/features/auth/infrastructure/repositories/auth_repository.dart';

// ---------------------------------------------------------------------------
// Infrastructure providers
// ---------------------------------------------------------------------------
final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final isArabic = ref.watch(appLocaleProvider).languageCode == 'ar';
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    isArabic: isArabic,
  );
});

// ---------------------------------------------------------------------------
// Auth state stream
// ---------------------------------------------------------------------------
final authStateProvider = StreamProvider<fb.User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ---------------------------------------------------------------------------
// Current user profile (fetched from Firestore)
// ---------------------------------------------------------------------------
final currentUserProfileProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final fbUser = authState.value;
  if (fbUser == null) return null;
  return ref.read(authRepositoryProvider).getUserProfile(fbUser.uid);
});

// ---------------------------------------------------------------------------
// Auth controller (login / register / sign out actions)
// ---------------------------------------------------------------------------
final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No-op initialization.
  }

  IAuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signInWithPhone(String phoneNumber, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signInWithPhone(phoneNumber, password),
    );
  }

  Future<void> registerWithEmail({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.registerWithEmail(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );
  }

  Future<AppUser> ensurePhoneUserAccount({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    state = const AsyncLoading();
    late final AppUser appUser;
    state = await AsyncValue.guard(() async {
      appUser = await _repo.ensurePhoneUserAccount(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
      );
    });
    return appUser;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signOut());
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }
}
