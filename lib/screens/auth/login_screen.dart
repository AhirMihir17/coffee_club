import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';
import 'signup_screen.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';
import 'widgets/auth_background.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: const IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28),
                        _BrandHeader(),
                        SizedBox(height: 36),
                        _LoginCard(),
                        Spacer(),
                        _Footer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

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
        const AppText.headline('Welcome back'),
        const SizedBox(height: 8),
        AppText.body(
          'Sign in with Google, Play Games, or email to continue.',
          color: AppTheme.muted(context),
          height: 1.4,
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<LoginCubit, AuthState>(
            builder: (context, state) {
              return AppButton.social(
                label: 'Continue with Google',
                isLoading: state is AuthLoading,
                icon: const Icon(Icons.person),
                onPressed: state is AuthLoading
                    ? null
                    : () => context.read<LoginCubit>().signInWithGoogle(),
              );
            },
          ),
          const SizedBox(height: 22),
          const AppOrDivider(label: 'or email & password'),
          const SizedBox(height: 18),
          const LoginForm(),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText("Don't have an account? ", color: AppTheme.muted(context)),
          GestureDetector(
            onTap: () => AppNavigator.push(context, const SignUpScreen()),
            child: const AppText.link('Create one'),
          ),
        ],
      ),
    );
  }
}
