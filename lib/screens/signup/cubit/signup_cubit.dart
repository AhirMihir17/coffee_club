import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repository/signup_repository.dart';
import '../model/signup_request_model.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository signupRepository;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = true;
  bool _isShimmerLoading = false;

  SignupCubit(this.signupRepository) : super(const SignupInitial());

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get agreeToTerms => _agreeToTerms;
  bool get isShimmerLoading => _isShimmerLoading;

  bool get isNameValid => _name.trim().length >= 2;
  bool get isEmailValid => _email.trim().isNotEmpty && _email.contains('@');
  bool get isPasswordValid => _password.length >= 6;
  bool get isConfirmPasswordValid =>
      _confirmPassword.isNotEmpty && _confirmPassword == _password;
  bool get isValid =>
      isNameValid &&
      isEmailValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      _agreeToTerms;

  String? get nameValidationError {
    if (_name.isEmpty) return null;
    return isNameValid ? null : 'Name must be at least 2 characters';
  }

  String? get emailValidationError {
    if (_email.isEmpty) return null;
    return isEmailValid ? null : 'Please enter a valid email address';
  }

  String? get passwordValidationError {
    if (_password.isEmpty) return null;
    return isPasswordValid ? null : 'Password must be at least 6 characters';
  }

  String? get confirmPasswordValidationError {
    if (_confirmPassword.isEmpty) return null;
    return isConfirmPasswordValid ? null : 'Passwords do not match';
  }

  void _emitInitial() {
    emit(const SignupInitial());
  }

  void updateName(String name) {
    _name = name;
    _emitInitial();
  }

  void updateEmail(String email) {
    _email = email;
    _emitInitial();
  }

  void updatePassword(String password) {
    _password = password;
    _emitInitial();
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _emitInitial();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    _emitInitial();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    _emitInitial();
  }

  void toggleAgreeToTerms([bool? value]) {
    _agreeToTerms = value ?? !_agreeToTerms;
    _emitInitial();
  }

  void toggleShimmer([bool? force]) {
    _isShimmerLoading = force ?? !_isShimmerLoading;
    _emitInitial();
  }

  void clearError() {
    _emitInitial();
  }

  Future<void> signUp() async {
    if (!isValid) {
      emit(const SignupError('Please fill out all required fields correctly.'));
      return;
    }

    emit(const SignupLoading());

    try {
      final request = EmailPasswordSignupRequest(
        name: _name.trim(),
        email: _email.trim(),
        password: _password,
      );

      final user = await signupRepository.createAccount(request);
      emit(SignupSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(SignupError(_messageForAuthError(e)));
    } catch (e) {
      emit(SignupError('Failed to create account: ${e.toString()}'));
    }
  }

  String _messageForAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Sign up failed. Please try again.';
    }
  }
}
