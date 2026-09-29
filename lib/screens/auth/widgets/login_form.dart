import 'package:firebase_learning/core/navigation/app_navigator.dart';
import 'package:firebase_learning/core/utils/toast_utils.dart';
import 'package:firebase_learning/screens/home/home_screen.dart';
import 'package:firebase_learning/screens/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_widgets.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<LoginCubit>().logIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppToast.showSuccess(context: context, message: "Login SuccessFully");
          AppNavigator.pushAndRemoveUntil(
            context,
            HomeScreen(user: state.user),
          );
        }

        if (state is AuthError) {
          AppToast.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        final canSubmit =
            !isLoading &&
            _emailController.text.trim().isNotEmpty &&
            _passwordController.text.length >= 6;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _emailController,
              hintText: 'Email address',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            AppTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (canSubmit) {
                  _submit();
                }
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: AppButton.text(
                label: 'Forgot password?',
                onPressed: () =>
                    AppNavigator.push(context, const ForgotPasswordScreen()),
              ),
            ),

            const SizedBox(height: 6),

            AppButton.primary(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: canSubmit ? _submit : null,
            ),
          ],
        );
      },
    );
  }
}
