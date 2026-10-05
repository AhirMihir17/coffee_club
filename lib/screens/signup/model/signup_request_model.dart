sealed class SignupRequest {
  const SignupRequest();
}

final class EmailPasswordSignupRequest extends SignupRequest {
  final String name;
  final String email;
  final String password;

  const EmailPasswordSignupRequest({
    required this.name,
    required this.email,
    required this.password,
  });
}
