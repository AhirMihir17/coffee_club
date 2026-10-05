import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import 'cubit/forgot_password_cubit.dart';
import 'cubit/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          AppToast.showSuccess(
            context: context,
            message: state.message,
          );
          AppNavigator.back(context);
        }
        if (state is ForgotPasswordError) {
          AppToast.showError(context: context, message: state.message);
        }
      },
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => AppNavigator.back(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(height: 24),
                  const _ForgotPasswordHeader(),
                  const SizedBox(height: 36),
                  const _ForgotPasswordCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordHeader extends StatelessWidget {
  const _ForgotPasswordHeader();

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
          child: const Icon(Icons.lock_reset_rounded, size: 32),
        ),
        const SizedBox(height: 22),
        const AppText.headline('Reset your password'),
        const SizedBox(height: 8),
        AppText.body(
          'Enter your email and we will send you a secure reset link.',
          color: AppTheme.muted(context),
          height: 1.4,
        ),
      ],
    );
  }
}

class _ForgotPasswordCard extends StatelessWidget {
  const _ForgotPasswordCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.all(22),
      borderRadius: 28,
      child: _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        final cubit = context.read<ForgotPasswordCubit>();
        final email = state is ForgotPasswordInitial ? state.email : cubit.email;
        final canSubmit = !isLoading && email.trim().isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _emailController,
              hintText: 'Email address',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onChanged: cubit.updateEmail,
              onSubmitted: (_) {
                if (canSubmit) _submit();
              },
            ),
            const SizedBox(height: 18),
            AppButton.primary(
              label: 'Send reset link',
              isLoading: isLoading,
              onPressed: canSubmit ? _submit : null,
            ),
            const SizedBox(height: 8),
            AppButton.text(
              label: 'Back to sign in',
              onPressed: isLoading ? null : () => AppNavigator.back(context),
            ),
          ],
        );
      },
    );
  }
}
