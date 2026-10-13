import '../../../core/model/user_model.dart';

abstract class LoginState {
  const LoginState();
}

int _loginStateCounter = 0;

class LoginInitial extends LoginState {
  final int id;

  LoginInitial([int? id]) : id = id ?? ++_loginStateCounter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginInitial && other.id == id);

  @override
  int get hashCode => id.hashCode;
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