abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  final String email;

  const ForgotPasswordInitial({this.email = ''});

  bool get isValid => email.trim().isNotEmpty && email.contains('@');
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordSuccess({
    this.message = 'Password reset email sent successfully.',
  });
}

class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;

  const ForgotPasswordError(this.errorMessage);

  String get message => errorMessage;
}
