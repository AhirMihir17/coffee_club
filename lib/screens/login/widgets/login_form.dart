import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/strings.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../../coffee/screens/main/coffee_main_screen.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<LoginCubit>();
    _emailController = TextEditingController(text: cubit.email);
    _passwordController = TextEditingController(text: cubit.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppToast.showSuccess(
            context: context,
            message: AppStrings.loginSuccessMessage,
          );
          AppNavigator.pushAndRemoveUntil(
            context,
            CoffeeMainScreen(user: state.user),
          );
        }

        if (state is LoginError) {
          AppToast.showError(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final cubit = context.read<LoginCubit>();

        // // Shimmer skeleton when loading
        // if (cubit.isShimmerLoading || isLoading) {
        //   return AuthCardShimmer(isDark: isDark);
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input Field (Controlled purely by Cubit)
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

            const SizedBox(height: 14),

            // Password Input Field (Obscurity & value toggled via Cubit)
            AppTextField(
              controller: _passwordController,
              hintText: AppStrings.passwordHint,
              labelText: AppStrings.passwordLabel,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !cubit.isPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              errorText: cubit.passwordValidationError,
              onChanged: cubit.updatePassword,
              onSubmitted: (_) {
                if (!isLoading) {
                  cubit.logIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }
              },
              suffixIcon: IconButton(
                icon: Icon(
                  cubit.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark ? Colors.white70 : const Color(0xFF6E5F55),
                  size: 20,
                ),
                onPressed: isLoading ? null : cubit.togglePasswordVisibility,
              ),
            ),

            const SizedBox(height: 10),

            // Remember Me & Forgot Password Row (Controlled via Cubit)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: isLoading ? null : cubit.toggleRememberMe,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Checkbox(
                            value: cubit.rememberMe,
                            activeColor: AppTheme.primaryCoffee,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: isLoading
                                ? null
                                : (_) => cubit.toggleRememberMe(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          AppStrings.rememberMe,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFA59B93)
                              : const Color(0xFF6E5F55),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: isLoading
                      ? null
                      : () => AppNavigator.push(
                            context,
                            const ForgotPasswordScreen(),
                          ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: AppText(
                      AppStrings.forgotPassword,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryCoffee,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Primary Sign-in Button
            AppButton.primary(
              label: AppStrings.signIn,
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => cubit.logIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
            ),
          ],
        );
      },
    );
  }
}
