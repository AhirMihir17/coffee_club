import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../coffee/screens/coffee_welcome_screen.dart';
import '../../core/constants/images.dart';
import '../../core/constants/strings.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';
import '../signup/signup_screen.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _LoginCard(),
                SizedBox(height: 12),
                _Footer(),
                SizedBox(height: 12),
              ],
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
          child: AppText.headline(AppStrings.welcomeBack),
        ),
        const SizedBox(height: 6),
        Center(
          child: AppText(
            AppStrings.welcomeBackSubtitle,
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

class _LoginCard extends StatelessWidget {
  const _LoginCard();

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
                        AppStrings.signIn,
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () =>
                        AppNavigator.pushReplacement(context, const SignUpScreen()),
                    child: Center(
                      child: AppText(
                        AppStrings.signUp,
                        color: isDark ? const Color(0xFFA59B93) : const Color(0xFF7E726A),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Sign In Form (completely driven by LoginCubit, zero setState)
          const LoginForm(),

          const SizedBox(height: 18),
          const AppOrDivider(label: AppStrings.orExploreRightAway),
          const SizedBox(height: 16),

          // Continue with Google Button
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              final cubit = context.read<LoginCubit>();

              return AppButton.social(
                label: AppStrings.continueWithGoogle,
                //isLoading: isLoading,
                icon: const Icon(
                  Icons.g_mobiledata_rounded,
                  size: 26,
                  color: Color(0xFF4285F4),
                ),
                onPressed: isLoading ? null : () => cubit.signInWithGoogle(),
              );
            },
          ),

          const SizedBox(height: 14),

          // Guest Explore Button
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.primaryCoffee.withValues(alpha: 0.12)
                  : const Color(0xFFF7EFE9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? AppTheme.primaryCoffee.withValues(alpha: 0.35)
                    : const Color(0xFFE2CFC2),
                width: 1.2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  AppNavigator.push(
                    context,
                    const CoffeeWelcomeScreen(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCoffee.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee_rounded,
                          color: AppTheme.primaryCoffee,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: AppText(
                          AppStrings.exploreAsGuest,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF241913),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF9E9289),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            AppStrings.dontHaveAccount,
            color: AppTheme.muted(context),
          ),
          GestureDetector(
            onTap: () =>
                AppNavigator.pushReplacement(context, const SignUpScreen()),
            child: const AppText.link(AppStrings.createOne),
          ),
        ],
      ),
    );
  }
}
