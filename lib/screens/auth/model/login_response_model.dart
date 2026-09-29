import '../../../core/model/user_model.dart';

class LoginResponse {
  final AppUser? user;
  final String? errorMessage;

  const LoginResponse({
    this.user,
    this.errorMessage,
  });

  const LoginResponse.success(AppUser user)
      : this(user: user);

  const LoginResponse.failure(String message)
      : this(errorMessage: message);

  bool get isSuccess => user != null;
  bool get hasError => errorMessage != null;
}
