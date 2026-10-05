import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/forgot_password_repository.dart';
import '../model/forgot_password_request_model.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  String _email = '';

  ForgotPasswordCubit(this.repository)
      : super(const ForgotPasswordInitial());

  String get email => _email;

  void updateEmail(String email) {
    _email = email;
    emit(ForgotPasswordInitial(email: _email));
  }

  Future<void> sendResetEmail([String? email]) async {
    final targetEmail = (email ?? _email).trim();
    if (targetEmail.isEmpty) {
      emit(const ForgotPasswordError('Please enter your email address.'));
      return;
    }

    emit(const ForgotPasswordLoading());
    try {
      await repository.sendResetEmail(ForgotPasswordRequest(email: targetEmail));
      emit(const ForgotPasswordSuccess());
    } on FirebaseAuthException catch (error) {
      emit(ForgotPasswordError(_messageForError(error)));
    } catch (e) {
      emit(ForgotPasswordError('Unable to send the reset email: ${e.toString()}'));
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
