import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/auth/model/forgot_password_request_model.dart';
import '../service/firebase_auth_service.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository(this.authService);

  final FirebaseAuthService authService;

  FirebaseAuth get _auth => authService.auth;

  Future<void> sendResetEmail(ForgotPasswordRequest request) {
    return _auth.sendPasswordResetEmail(email: request.email.trim());
  }
}
