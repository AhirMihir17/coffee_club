import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import '../home/home_screen.dart';
import 'cubit/signup_cubit.dart';
import 'cubit/signup_state.dart';
import 'widgets/auth_background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          AppToast.showSuccess(
            context: context,
            message: 'Account created successfully',
          );
          AppNavigator.pushAndRemoveUntil(
            context,
            HomeScreen(user: state.user),
          );
        }
        if (state is SignupError) {
          AppToast.showError(context: context, message: state.message);
        }
      },
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const _SignUpHeader(),
                  const SizedBox(height: 36),
                  const _SignUpCard(),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          'Already have an account? ',
                          color: AppTheme.muted(context),
                        ),
                        GestureDetector(
                          onTap: () => AppNavigator.back(context),
                          child: const AppText.link('Sign in'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpHeader extends StatelessWidget {
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [AppTheme.accent, AppTheme.mint],
            ),
          ),
          child: const Icon(Icons.bolt_rounded, size: 32),
        ),
        const SizedBox(height: 22),
        const AppText.headline('Create your account'),
        const SizedBox(height: 8),
        AppText.body(
          'Use your email and a password to get started.',
          color: AppTheme.muted(context),
          height: 1.4,
        ),
      ],
    );
  }
}

class _SignUpCard extends StatelessWidget {
  const _SignUpCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      borderRadius: 28,
      child: const _SignUpForm(),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_passwordController.text != _confirmPasswordController.text) {
      AppToast.showError(context: context, message: 'Passwords do not match.');
      return;
    }
    context.read<SignupCubit>().createAccount(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final isLoading = state is SignupLoading;
        final canSubmit =
            !isLoading &&
            _nameController.text.trim().isNotEmpty &&
            _emailController.text.trim().isNotEmpty &&
            _passwordController.text.length >= 6 &&
            _confirmPasswordController.text.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _nameController,
              hintText: 'Full name',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
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
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !_isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (canSubmit) _submit();
              },
              suffixIcon: IconButton(
                onPressed: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            const SizedBox(height: 18),
            AppButton.primary(
              label: 'Create account',
              isLoading: isLoading,
              onPressed: canSubmit ? _submit : null,
            ),
          ],
        );
      },
    );
  }
}
