import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_club/core/service/firebase_auth_service.dart';
import 'package:coffee_club/core/repository/auth_repository.dart';
import 'package:coffee_club/core/repository/signup_repository.dart';
import 'package:coffee_club/screens/login/cubit/login_cubit.dart';
import 'package:coffee_club/screens/login/cubit/login_state.dart';
import 'package:coffee_club/screens/signup/cubit/signup_cubit.dart';
import 'package:coffee_club/screens/signup/cubit/signup_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginCubit', () {
    late LoginCubit loginCubit;

    setUp(() {
      final authService = FirebaseAuthService();
      final repository = AuthRepository(authService);
      loginCubit = LoginCubit(repository);
    });

    tearDown(() {
      loginCubit.close();
    });

    test('initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
      expect(loginCubit.isValid, isFalse);
    });

    test('updateEmail and updatePassword emit new LoginInitial states', () async {
      final states = <LoginState>[];
      final subscription = loginCubit.stream.listen(states.add);

      loginCubit.updateEmail('test@example.com');
      loginCubit.updatePassword('password123');

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(states.length, 2);
      expect(states.every((s) => s is LoginInitial), isTrue);
      expect(loginCubit.isValid, isTrue);
    });

    test('logIn with empty email emits LoginError', () async {
      final states = <LoginState>[];
      final subscription = loginCubit.stream.listen(states.add);

      await loginCubit.logIn(email: '', password: '');

      await subscription.cancel();
      expect(states.last, isA<LoginError>());
      final error = states.last as LoginError;
      expect(error.errorMessage, contains('email address'));
    });

    test('logIn with short password emits LoginError', () async {
      final states = <LoginState>[];
      final subscription = loginCubit.stream.listen(states.add);

      await loginCubit.logIn(email: 'user@example.com', password: '123');

      await subscription.cancel();
      expect(states.last, isA<LoginError>());
      final error = states.last as LoginError;
      expect(error.errorMessage, contains('6 characters'));
    });

    test('togglePasswordVisibility emits a new state', () async {
      final states = <LoginState>[];
      final subscription = loginCubit.stream.listen(states.add);

      expect(loginCubit.isPasswordVisible, isFalse);
      loginCubit.togglePasswordVisibility();
      expect(loginCubit.isPasswordVisible, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(states.isNotEmpty, isTrue);
    });
  });

  group('SignupCubit', () {
    late SignupCubit signupCubit;

    setUp(() {
      final authService = FirebaseAuthService();
      final repository = SignupRepository(authService);
      signupCubit = SignupCubit(repository);
    });

    tearDown(() {
      signupCubit.close();
    });

    test('initial state is SignupInitial', () {
      expect(signupCubit.state, isA<SignupInitial>());
      expect(signupCubit.isValid, isFalse);
    });

    test('typing fields emits consecutive SignupInitial states and updates validity', () async {
      final states = <SignupState>[];
      final subscription = signupCubit.stream.listen(states.add);

      signupCubit.updateName('John Doe');
      signupCubit.updateEmail('john@example.com');
      signupCubit.updatePassword('secure123');
      signupCubit.updateConfirmPassword('secure123');

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(states.length, 4);
      expect(signupCubit.isValid, isTrue);
    });

    test('signUp with empty inputs emits validation error', () async {
      final states = <SignupState>[];
      final subscription = signupCubit.stream.listen(states.add);

      await signupCubit.signUp();

      await subscription.cancel();
      expect(states.last, isA<SignupError>());
      final error = states.last as SignupError;
      expect(error.errorMessage, contains('full name'));
    });

    test('signUp with mismatched passwords emits validation error', () async {
      final states = <SignupState>[];
      final subscription = signupCubit.stream.listen(states.add);

      await signupCubit.signUp(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        confirmPassword: 'different123',
      );

      await subscription.cancel();
      expect(states.last, isA<SignupError>());
      final error = states.last as SignupError;
      expect(error.errorMessage, contains('do not match'));
    });
  });
}
