import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../service/firebase_auth_service.dart';

class AuthRepository {
  AuthRepository(this.authService);

  final FirebaseAuthService authService;

  FirebaseAuth get _auth => authService.auth;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User details not found after signing in.',
        );
      }

      return AppUser.fromFirebaseUser(user);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<AppUser> signInWithGoogle() async {
    try {
      throw UnimplementedError('Google sign in is not configured yet.');
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }
}
