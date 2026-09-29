import 'package:firebase_auth/firebase_auth.dart';

import '../service/firebase_auth_service.dart';
import '../model/user_model.dart';

class AuthRepository {
  AuthRepository(this.authService);

  final FirebaseAuthService authService;

  FirebaseAuth get _auth => authService.auth;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User user = credential.user!;

    return AppUser.fromFirebaseUser(user);
  }

  Future<AppUser> signInWithGoogle() async {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
