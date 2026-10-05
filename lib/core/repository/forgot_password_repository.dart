import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/forgot_password/model/forgot_password_request_model.dart';
import '../service/firebase_auth_service.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository(this.authService);

  final FirebaseAuthService authService;

  FirebaseAuth get _auth => authService.auth;

  Future<void> sendResetEmail(ForgotPasswordRequest request) async {
    try {
      await _auth.sendPasswordResetEmail(email: request.email.trim());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }
}
