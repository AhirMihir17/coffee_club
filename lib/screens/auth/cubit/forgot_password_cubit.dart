import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/forgot_password_repository.dart';
import '../model/forgot_password_request_model.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.repository) : super(ForgotPasswordInitial());

  final ForgotPasswordRepository repository;

  Future<void> sendResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await repository.sendResetEmail(ForgotPasswordRequest(email: email));
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (error) {
      emit(ForgotPasswordError(_messageForError(error)));
    } catch (_) {
      emit(ForgotPasswordError('Unable to send the reset email.'));
    }
  }

  String _messageForError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-not-found':
        return 'No account was found with this email.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return error.message ?? 'Unable to send the reset email.';
    }
  }
}
