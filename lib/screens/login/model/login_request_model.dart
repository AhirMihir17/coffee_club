sealed class LoginRequest {
  const LoginRequest();
}

final class EmailPasswordRequest extends LoginRequest {
  final String email;
  final String password;

  const EmailPasswordRequest({
    required this.email,
    required this.password,
  });
}

final class GoogleLoginRequest extends LoginRequest {
  const GoogleLoginRequest();
}
