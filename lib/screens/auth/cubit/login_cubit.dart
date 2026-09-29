import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/core/repository/auth_repository.dart';
import 'package:firebase_learning/screens/auth/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<AuthState> {
  AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(AuthInitial());

  Future<void> logIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_messageForAuthError(e)));
    } catch (e) {
      emit(AuthError('Unable to sign in. Please try again.'));
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
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Unable to sign in. Please try again.';
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());

      final user = await authRepository.signInWithGoogle();

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Google sign in failed'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError('Failed to sign out. Please try again.'));
      rethrow;
    }
  }
}
