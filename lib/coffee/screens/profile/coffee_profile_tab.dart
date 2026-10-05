import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/model/user_model.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../screens/login/cubit/login_cubit.dart';
import '../../../screens/login/login_screen.dart';
import '../../widgets/coffee_svg_icon.dart';
import '../coffee_welcome_screen.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class CoffeeProfileTab extends StatelessWidget {
  final AppUser? user;

  const CoffeeProfileTab({super.key, this.user});

  Future<void> _handleSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const AppText(
          AppStrings.signOut,
          fontWeight: FontWeight.w700,
        ),
        content: AppText(
          AppStrings.signOutConfirmation,
          color: AppTheme.muted(dialogContext),
        ),
        actions: [
          AppButton.text(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            label: AppStrings.cancel,
          ),
          AppButton.text(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            label: AppStrings.signOut,
            foregroundColor: Colors.redAccent,
          ),
        ],
      ),
    );

    if (shouldSignOut != true || !context.mounted) return;

    try {
      await context.read<LoginCubit>().logout();
      if (!context.mounted) return;
      AppToast.showSuccess(
        context: context,
        message: 'Signed out successfully',
      );
      AppNavigator.pushAndRemoveUntil(
        context,
        const LoginScreen(),
      );
    } catch (_) {
      if (!context.mounted) return;
      AppToast.showError(
        context: context,
        message: 'Failed to sign out. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = user?.displayName.trim();
    final name = (displayName != null &&
            displayName.isNotEmpty &&
            displayName != 'NULL')
        ? displayName
        : 'Alex Morgan';
    final email = user?.email ?? 'alex.morgan@coffeelover.com';

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              AppText(
                AppStrings.profileTitle,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF241913),
              ),
              const SizedBox(height: 18),

              // User Info Card
              AppCard(
                padding: const EdgeInsets.all(18),
                borderRadius: 22,
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFEDE5DF),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryCoffee,
                          width: 2,
                        ),
                      ),
                      child: const CustomCachedImage(
                        imageUrl: AppImages.pngAvatar,
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        fit: BoxFit.cover,
                        fallbackIcon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            name,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF241913),
                          ),
                          const SizedBox(height: 3),
                          AppText(
                            email,
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFA59B93)
                                : const Color(0xFF86766B),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryCoffee
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const AppText(
                              AppStrings.goldBeanMember,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryCoffee,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Coffee Rewards Stamp Card (ProfileCubit)
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(color: AppTheme.primaryCoffee),
                      ),
                    );
                  }

                  if (state is ProfileError) {
                    return Center(
                      child: AppText(
                        state.errorMessage,
                        color: Colors.redAccent,
                      ),
                    );
                  }

                  final stamps = state is ProfileSuccess ? state.beanStamps : 4;

                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF382318),
                          Color(0xFF241710),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF382318).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppText(
                              AppStrings.loyaltyCardTitle,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                            AppText(
                              '$stamps / 10',
                              color: const Color(0xFFE3B899),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          '${10 - stamps} more cups until your next FREE handcrafted brew!',
                          color: const Color(0xFFEDE0D4),
                          fontSize: 12,
                        ),
                        const SizedBox(height: 14),
                        // 10 Stamp Circles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(10, (index) {
                            final isStamped = index < stamps;
                            return InkWell(
                              onTap: () =>
                                  context.read<ProfileCubit>().addStamp(),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isStamped
                                      ? AppTheme.primaryCoffee
                                      : Colors.white.withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: isStamped
                                        ? const Color(0xFFE3B899)
                                        : Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: isStamped
                                      ? const CoffeeSvgIcon(
                                          assetName: AppImages.svgCoffeeCup,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : AppText(
                                          '${index + 1}',
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Preferences & Settings List
              AppText(
                AppStrings.settingsTitle,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF241913),
              ),
              const SizedBox(height: 10),

              AppCard(
                padding: EdgeInsets.zero,
                borderRadius: 20,
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFEDE5DF),
                child: Column(
                  children: [
                    // Theme Switch using AppSwitch
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDarkMode = themeMode == ThemeMode.dark;
                        return ListTile(
                          leading: Icon(
                            isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: AppTheme.primaryCoffee,
                          ),
                          title: AppText(
                            AppStrings.darkMode,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF241913),
                          ),
                          trailing: AppSwitch(
                            value: isDarkMode,
                            activeColor: AppTheme.primaryCoffee,
                            onChanged: (val) {
                              context.read<ThemeCubit>().toggleTheme(val);
                            },
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFEDE5DF),
                    ),
                    // Welcome screen preview
                    ListTile(
                      leading: const Icon(
                        Icons.storefront_rounded,
                        color: AppTheme.primaryCoffee,
                      ),
                      title: AppText(
                        AppStrings.viewWelcomeScreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF241913),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CoffeeWelcomeScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFEDE5DF),
                    ),
                    // Sourcing info
                    ListTile(
                      leading: const CoffeeSvgIcon(
                        assetName: AppImages.svgCoffeeBean,
                        size: 20,
                        color: AppTheme.primaryCoffee,
                      ),
                      title: AppText(
                        AppStrings.beanSourcing,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF241913),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: isDark
                                ? AppTheme.darkRoast
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const AppText(
                              AppStrings.ethicalSourcingTitle,
                              fontWeight: FontWeight.w800,
                            ),
                            content: const AppText(
                              AppStrings.ethicalSourcingBody,
                              fontSize: 13,
                              height: 1.5,
                            ),
                            actions: [
                              AppButton.text(
                                onPressed: () => Navigator.pop(ctx),
                                label: AppStrings.close,
                                foregroundColor: AppTheme.primaryCoffee,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sign Out Button using AppButton.outlined
              AppButton.outlined(
                label: AppStrings.signOut,
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFED5151),
                  size: 18,
                ),
                foregroundColor: const Color(0xFFED5151),
                borderColor: const Color(0xFFED5151),
                height: 50,
                onPressed: () => _handleSignOut(context),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
