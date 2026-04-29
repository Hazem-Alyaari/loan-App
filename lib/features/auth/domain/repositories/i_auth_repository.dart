import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:loan/features/auth/domain/models/app_user.dart';

/// Contract for authentication operations.
abstract class IAuthRepository {
  /// Stream of auth state changes. Emits null when signed out.
  Stream<fb.User?> get authStateChanges;

  /// Currently signed-in Firebase user, or null.
  fb.User? get currentUser;

  /// Sign in with phone number and password.
  Future<AppUser> signInWithPhone(String phoneNumber, String password);

  /// Register with phone number and password, creating a user document.
  Future<AppUser> registerWithEmail({
    required String fullName,
    required String phoneNumber,
    required String password,
  });

  /// Ensure a login-enabled account exists for a phone number.
  Future<AppUser> ensurePhoneUserAccount({
    required String fullName,
    required String phoneNumber,
    required String password,
  });

  /// Sign in with Google.
  Future<AppUser> signInWithGoogle();

  /// Sign out the current user.
  Future<void> signOut();

  /// Fetch user document from Firestore.
  Future<AppUser?> getUserProfile(String userId);

  /// Update user profile in Firestore.
  Future<void> updateUserProfile(AppUser user);

  /// Change the current user's password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
