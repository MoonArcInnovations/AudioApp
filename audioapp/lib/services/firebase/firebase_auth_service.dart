import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/auth/domain/entities/app_user.dart';

/// Firebase Authentication Service
class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Current user stream
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  /// Current user
  fb.User? get currentUser => _auth.currentUser;

  /// Sign in with email and password
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await _getUserData(credential.user!.uid);
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register new user
  Future<AppUser?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);

        // Create user document in Firestore
        final user = AppUser(
          id: credential.user!.uid,
          email: email,
          name: name,
          phoneNumber: null,
          role: role,
          verificationState: UserVerificationState.defaultForRole(role),
          createdAt: DateTime.now(),
        );

        await _createUserDocument(user);
        return user;
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get user data from Firestore
  Future<AppUser?> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final role = UserRole.values.firstWhere(
          (r) => r.name == data['role'],
          orElse: () => UserRole.patient,
        );
        return AppUser(
          id: uid,
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          phoneNumber: data['phoneNumber'],
          role: role,
          verificationState: UserVerificationState.fromStorageValue(
            data['verificationState'] as String?,
            role: role,
          ),
          avatarUrl: data['avatarUrl'],
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return _getUserData(user.uid);
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'role': user.role.name,
      'verificationState': user.verificationState.name,
      'avatarUrl': user.avatarUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> upsertUserAccessProfile({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
    required UserVerificationState verificationState,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'verificationState': verificationState.name,
      'avatarUrl': avatarUrl,
    }, SetOptions(merge: true));
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    updates['phoneNumber'] = phoneNumber;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updates);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
