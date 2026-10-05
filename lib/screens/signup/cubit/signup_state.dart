import '../model/signup_user_model.dart';

abstract class SignupState {
  const SignupState();
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final SignupUser user;

  const SignupSuccess(this.user);
}

class SignupError extends SignupState {
  final String errorMessage;

  const SignupError(this.errorMessage);
}
