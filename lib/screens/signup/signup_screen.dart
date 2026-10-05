import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/images.dart';
import '../../core/constants/strings.dart';
import '../../core/model/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import '../../coffee/screens/main/coffee_main_screen.dart';
import '../login/login_screen.dart';
import 'cubit/signup_cubit.dart';
import 'cubit/signup_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          AppToast.showSuccess(
            context: context,
            message: 'Welcome to Artisan Coffee, ${state.user.name}!',
          );
          final appUser = AppUser(
            id: state.user.id,
            email: state.user.email,
            displayName: state.user.name,
            provider: AuthProviderType.email,
          );
          AppNavigator.pushAndRemoveUntil(
            context,
            CoffeeMainScreen(user: appUser),
          );
        }

        if (state is SignupError) {
          AppToast.showError(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        body: AuthBackground(
          backgroundImage: AppImages.imgHeroCoffee,
          showImage: true,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  _BrandHeader(),
                  SizedBox(height: 18),
                  _SignUpCard(),
                  SizedBox(height: 12),
                  _Footer(),
                  SizedBox(height: 12),
                ],
              ),
            ),
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
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCoffee.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AppImages.pngAppLogo,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: AppText(
            AppStrings.appName,
            fontSize: 14,
            letterSpacing: 3,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryCoffee,
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: AppText.headline(AppStrings.createAccountHeadline),
        ),
        const SizedBox(height: 6),
        Center(
          child: AppText(
            AppStrings.createAccountSubtitle,
            textAlign: TextAlign.center,
            fontSize: 13,
            color: AppTheme.muted(context),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _SignUpCard extends StatelessWidget {
  const _SignUpCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Segmented Tab Switcher (Sign In vs Sign Up)
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF19120E) : const Color(0xFFF1E7DF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () =>
                        AppNavigator.pushReplacement(context, const LoginScreen()),
                    child: Center(
                      child: AppText(
                        AppStrings.signIn,
                        color: isDark ? const Color(0xFFA59B93) : const Color(0xFF7E726A),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCoffee,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryCoffee.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: AppText(
                        AppStrings.signUp,
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Sign Up Form (100% Cubit-driven, ZERO setState)
          const _SignUpForm(),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignupCubit>();
    _nameController = TextEditingController(text: cubit.name);
    _emailController = TextEditingController(text: cubit.email);
    _passwordController = TextEditingController(text: cubit.password);
    _confirmPasswordController =
        TextEditingController(text: cubit.confirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final isLoading = state is SignupLoading;
        final cubit = context.read<SignupCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            AppTextField(
              controller: _nameController,
              hintText: AppStrings.nameHint,
              labelText: AppStrings.nameLabel,
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              errorText: cubit.nameValidationError,
              onChanged: cubit.updateName,
            ),
            const SizedBox(height: 12),

            // Email Field
            AppTextField(
              controller: _emailController,
              hintText: AppStrings.emailHint,
              labelText: AppStrings.emailLabel,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              errorText: cubit.emailValidationError,
              onChanged: cubit.updateEmail,
            ),
            const SizedBox(height: 12),

            // Password Field
            AppTextField(
              controller: _passwordController,
              hintText: AppStrings.passwordHint,
              labelText: AppStrings.passwordLabel,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !cubit.isPasswordVisible,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              errorText: cubit.passwordValidationError,
              onChanged: cubit.updatePassword,
              suffixIcon: IconButton(
                onPressed: isLoading ? null : cubit.togglePasswordVisibility,
                icon: Icon(
                  cubit.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark ? Colors.white70 : const Color(0xFF6E5F55),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Confirm Password Field
            AppTextField(
              controller: _confirmPasswordController,
              hintText: AppStrings.confirmPasswordHint,
              labelText: AppStrings.confirmPasswordLabel,
              prefixIcon: Icons.lock_clock_outlined,
              obscureText: !cubit.isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              errorText: cubit.confirmPasswordValidationError,
              onChanged: cubit.updateConfirmPassword,
              onSubmitted: (_) {
                if (cubit.isValid && !isLoading) {
                  cubit.signUp();
                }
              },
              suffixIcon: IconButton(
                onPressed:
                    isLoading ? null : cubit.toggleConfirmPasswordVisibility,
                icon: Icon(
                  cubit.isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark ? Colors.white70 : const Color(0xFF6E5F55),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Terms and Conditions Checkbox
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: isLoading ? null : cubit.toggleAgreeToTerms,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: cubit.agreeToTerms,
                        activeColor: AppTheme.primaryCoffee,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: isLoading
                            ? null
                            : (_) => cubit.toggleAgreeToTerms(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        AppStrings.agreeToTerms,
                        fontSize: 11.5,
                        color: isDark
                            ? const Color(0xFFA59B93)
                            : const Color(0xFF6E5F55),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Submit Button
            AppButton.primary(
              label: AppStrings.createAccount,
              isLoading: isLoading,
              onPressed: cubit.isValid && !isLoading
                  ? () => cubit.signUp()
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            AppStrings.alreadyHaveAccount,
            color: AppTheme.muted(context),
          ),
          GestureDetector(
            onTap: () =>
                AppNavigator.pushReplacement(context, const LoginScreen()),
            child: const AppText.link(AppStrings.signIn),
          ),
        ],
      ),
    );
  }
}
