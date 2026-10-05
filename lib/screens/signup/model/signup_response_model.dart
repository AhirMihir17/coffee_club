import 'signup_user_model.dart';

class SignupResponse {
  final SignupUser? user;
  final String? errorMessage;

  const SignupResponse({this.user, this.errorMessage});

  const SignupResponse.success(SignupUser user) : this(user: user);

  const SignupResponse.failure(String message) : this(errorMessage: message);

  bool get isSuccess => user != null;
  bool get hasError => errorMessage != null;
}
