import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../service/firebase_auth_service.dart';
import '../../screens/signup/model/signup_request_model.dart';
import '../../screens/signup/model/signup_user_model.dart';

class SignupRepository {
  SignupRepository(this.authService);

  final FirebaseAuthService authService;

  FirebaseAuth get _auth => authService.auth;

  Future<SignupUser> createAccount(EmailPasswordSignupRequest request) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: request.email.trim(),
            password: request.password,
          );

      final User? user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Failed to create user account.',
        );
      }

      await user.updateDisplayName(request.name.trim());

      return SignupUser(
        id: user.uid,
        name: request.name.trim(),
        email: user.email ?? 'NULL',
        provider: AuthProviderType.email,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }
}
