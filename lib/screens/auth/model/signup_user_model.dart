import '../../../core/model/user_model.dart';

class SignupUser extends AppUser {
  const SignupUser({
    required super.id,
    required this.name,
    required super.email,
    required super.provider,
  }) : super(displayName: name);

  final String name;
}
