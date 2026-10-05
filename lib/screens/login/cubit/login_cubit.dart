import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repository/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _rememberMe = true;
  bool _isShimmerLoading = false;

  LoginCubit(this.authRepository) : super(const LoginInitial());

  String get email => _email;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get rememberMe => _rememberMe;
  bool get isShimmerLoading => _isShimmerLoading;

  bool get isEmailValid => _email.trim().isNotEmpty && _email.contains('@');
  bool get isPasswordValid => _password.length >= 6;
  bool get isValid => isEmailValid && isPasswordValid;

  String? get emailValidationError {
    if (_email.isEmpty) return null;
    return isEmailValid ? null : 'Please enter a valid email address';
  }

  String? get passwordValidationError {
    if (_password.isEmpty) return null;
    return isPasswordValid ? null : 'Password must be at least 6 characters';
  }

  void _emitInitial() {
    emit(const LoginInitial());
  }

  void updateEmail(String email) {
    _email = email;
    _emitInitial();
  }

  void updatePassword(String password) {
    _password = password;
    _emitInitial();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    _emitInitial();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    _emitInitial();
  }

  void toggleShimmer([bool? force]) {
    _isShimmerLoading = force ?? !_isShimmerLoading;
    _emitInitial();
  }

  void clearError() {
    _emitInitial();
  }

  Future<void> logIn({String? email, String? password}) async {
    final targetEmail = (email ?? _email).trim();
    final targetPassword = password ?? _password;

    if (targetEmail.isEmpty || targetPassword.length < 6) {
      emit(const LoginError(
        'Please enter a valid email and 6+ character password.',
      ));
      return;
    }

    emit(const LoginLoading());

    try {
      final user = await authRepository.signInWithEmail(
        email: targetEmail,
        password: targetPassword,
      );
      emit(LoginSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(_messageForAuthError(e)));
    } catch (e) {
      emit(LoginError('Unable to sign in: ${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());

    try {
      final user = await authRepository.signInWithGoogle();
      emit(LoginSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'Google sign in failed.'));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.signOut();
      _email = '';
      _password = '';
      _isPasswordVisible = false;
      _isShimmerLoading = false;
      emit(const LoginInitial());
    } catch (e) {
      emit(LoginError('Failed to sign out: ${e.toString()}'));
    }
  }

  String _messageForAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'wrong-password':
      case 'user-not-found':
        return 'The email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again in a few moments.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Unable to sign in. Please try again.';
    }
  }
}
