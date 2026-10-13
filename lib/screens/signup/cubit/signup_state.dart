import '../model/signup_user_model.dart';

abstract class SignupState {
  const SignupState();
}

int _signupStateCounter = 0;

class SignupInitial extends SignupState {
  final int id;

  SignupInitial([int? id]) : id = id ?? ++_signupStateCounter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignupInitial && other.id == id);

  @override
  int get hashCode => id.hashCode;
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
