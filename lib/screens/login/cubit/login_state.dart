import '../../../core/model/user_model.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final AppUser user;

  const LoginSuccess({required this.user});
}

class LoginError extends LoginState {
  final String errorMessage;

  const LoginError(this.errorMessage);
}