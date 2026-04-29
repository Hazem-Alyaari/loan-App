import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:loan/core/enums/enums.dart';
import 'package:loan/features/auth/domain/models/app_user.dart';
import 'package:loan/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:loan/firebase_options.dart';

class AuthRepository implements IAuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  @override
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  @override
  fb.User? get currentUser => _auth.currentUser;

  @override
  Future<AppUser> signInWithPhone(String phoneNumber, String password) async {
    final normalizedPhone = _normalizePhone(phoneNumber);
    final email = '$normalizedPhone@loantrack.local';

    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    final profile = await getUserProfile(user.uid);
    if (profile != null) return profile;
    throw Exception('لم يتم العثور على ملف المستخدم');
  }

  @override
  Future<AppUser> registerWithEmail({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber);
    final email = '$normalizedPhone@loantrack.local';
    late final fb.UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('رقم الهاتف مسجل بالفعل');
      }
      rethrow;
    }
    final user = credential.user!;
    await user.updateDisplayName(fullName);

    final appUser = AppUser(
      id: user.uid,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber.trim(),
      phoneNormalized: normalizedPhone,
      authProvider: AuthProvider.email,
      providerId: user.uid,
      createdAt: DateTime.now(),
    );

    await _usersRef.doc(user.uid).set(appUser.toJson());
    return appUser;
  }

  @override
  Future<AppUser> ensurePhoneUserAccount({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber);
    final existing = await _usersRef
        .where('phoneNormalized', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final profile = AppUser.fromFirestore(doc);
      final currentName = profile.fullName.trim();
      if (fullName.trim().isNotEmpty && currentName != fullName.trim()) {
        await _usersRef.doc(doc.id).update({'fullName': fullName.trim()});
        return profile.copyWith(fullName: fullName.trim());
      }
      return profile;
    }

    final tempAppName = 'member-${DateTime.now().microsecondsSinceEpoch}';
    FirebaseApp? tempApp;
    fb.FirebaseAuth? tempAuth;

    try {
      tempApp = await Firebase.initializeApp(
        name: tempAppName,
        options: DefaultFirebaseOptions.currentPlatform,
      );
      tempAuth = fb.FirebaseAuth.instanceFor(app: tempApp);
      final email = '$normalizedPhone@loantrack.local';
      final credential = await tempAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(fullName.trim());

      final appUser = AppUser(
        id: user.uid,
        fullName: fullName.trim(),
        email: email,
        phoneNumber: phoneNumber.trim(),
        phoneNormalized: normalizedPhone,
        authProvider: AuthProvider.email,
        providerId: user.uid,
        mustChangePassword: true,
        createdAt: DateTime.now(),
      );

      await _usersRef.doc(user.uid).set(appUser.toJson());
      return appUser;
    } finally {
      await tempAuth?.signOut();
      if (tempApp != null) {
        await tempApp.delete();
      }
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final googleProvider = fb.GoogleAuthProvider();
    final credential = await _auth.signInWithProvider(googleProvider);
    final user = credential.user!;

    // Check if user doc exists; if not, create it.
    final doc = await _usersRef.doc(user.uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }

    final appUser = AppUser(
      id: user.uid,
      fullName: user.displayName ?? 'Unknown',
      email: user.email ?? '',
      phoneNumber: user.phoneNumber,
      authProvider: AuthProvider.google,
      providerId: user.uid,
      createdAt: DateTime.now(),
    );

    await _usersRef.doc(user.uid).set(appUser.toJson());
    return appUser;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser?> getUserProfile(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  @override
  Future<void> updateUserProfile(AppUser user) async {
    await _usersRef.doc(user.id).update(user.toJson());
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل الدخول');
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw Exception('الحساب الحالي لا يدعم تغيير كلمة المرور');
    }

    final credential = fb.EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
    await _usersRef.doc(user.uid).update({'mustChangePassword': false});
  }

  String _normalizePhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digitsOnly.isEmpty) {
      throw Exception('رقم الهاتف مطلوب');
    }
    return digitsOnly;
  }
}
