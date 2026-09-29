import '../model/signup_user_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupUser user;

  SignupSuccess(this.user);
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}
