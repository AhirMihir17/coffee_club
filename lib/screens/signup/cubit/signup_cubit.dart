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

  SignupCubit(this.signupRepository) : super(SignupInitial());

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
    emit(SignupInitial());
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

  void reset() {
    _name = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _agreeToTerms = true;
    _isShimmerLoading = false;
    _emitInitial();
  }

  Future<void> signUp({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {
    final targetName = (name ?? _name).trim();
    final targetEmail = (email ?? _email).trim();
    final targetPassword = password ?? _password;
    final targetConfirmPassword = confirmPassword ?? _confirmPassword;

    if (targetName.isEmpty) {
      emit(const SignupError('Please enter your full name.'));
      return;
    }
    if (targetName.length < 2) {
      emit(const SignupError('Name must be at least 2 characters.'));
      return;
    }
    if (targetEmail.isEmpty) {
      emit(const SignupError('Please enter your email address.'));
      return;
    }
    if (!targetEmail.contains('@')) {
      emit(const SignupError('Please enter a valid email address.'));
      return;
    }
    if (targetPassword.isEmpty) {
      emit(const SignupError('Please enter a password.'));
      return;
    }
    if (targetPassword.length < 6) {
      emit(const SignupError('Password must be at least 6 characters.'));
      return;
    }
    if (targetConfirmPassword.isEmpty) {
      emit(const SignupError('Please confirm your password.'));
      return;
    }
    if (targetPassword != targetConfirmPassword) {
      emit(const SignupError('Passwords do not match.'));
      return;
    }
    if (!_agreeToTerms) {
      emit(const SignupError('Please accept the Terms and Conditions.'));
      return;
    }

    emit(const SignupLoading());

    try {
      final request = EmailPasswordSignupRequest(
        name: targetName,
        email: targetEmail,
        password: targetPassword,
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
