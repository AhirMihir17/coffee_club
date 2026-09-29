import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/signup_repository.dart';
import '../model/signup_request_model.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository signupRepository;

  SignupCubit(this.signupRepository) : super(SignupInitial());

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    try {
      final user = await signupRepository.createAccount(
        EmailPasswordSignupRequest(
          name: name,
          email: email,
          password: password,
        ),
      );
      emit(SignupSuccess(user));
    } on FirebaseAuthException catch (error) {
      emit(SignupError(_messageForError(error)));
    } catch (_) {
      emit(SignupError('Unable to create your account. Please try again.'));
    }
  }

  String _messageForError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Unable to create your account.';
    }
  }
}
