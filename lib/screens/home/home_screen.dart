import 'package:firebase_learning/core/theme/theme_cubit.dart';
import 'package:firebase_learning/core/widgets/app_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../core/model/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import '../auth/cubit/login_cubit.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser user;

  Future<void> _handleSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const AppText.title('Sign out'),
        content: AppText.body(
          'Are you sure you want to sign out of your account?',
          color: AppTheme.muted(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const AppText.body('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const AppText.body(
              'Sign out',
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
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

  String get _firstName {
    final name = user.displayName.trim();
    if (name.isEmpty || name == 'NULL') return 'there';
    return name.split(' ').first;
  }

  String get _initials {
    final name = user.displayName.trim();
    if (name.isEmpty || name == 'NULL') return '?';
    final parts = name.split(RegExp(r'\s+'));
    return parts.length == 1
        ? parts.first.substring(0, 1).toUpperCase()
        : '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get _providerLabel {
    return switch (user.provider) {
      AuthProviderType.email => 'Email & password',
      AuthProviderType.google => 'Google',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(
                initials: _initials,
                onSignOut: () => _handleSignOut(context),
              ),
              const SizedBox(height: 30),
              AppText.body('Good to see you,', color: AppTheme.muted(context)),
              const SizedBox(height: 4),
              AppText.headline('Hello, $_firstName'),
              const SizedBox(height: 24),
              _AccountOverview(user: user, providerLabel: _providerLabel),
              const SizedBox(height: 24),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                borderRadius: 20,
                child: Row(
                  children: [
                    const Icon(Icons.palette_outlined, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: AppText.label('Dark Mode Theme')),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDark =
                            themeMode == ThemeMode.dark ||
                            (themeMode == ThemeMode.system &&
                                Theme.of(context).brightness ==
                                    Brightness.dark);

                        return AppSwitch(
                          value: isDark,
                          onChanged: (isDark) {
                            context.read<ThemeCubit>().toggleTheme(isDark);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const AppText.title('Quick actions'),
              const SizedBox(height: 14),
              const _QuickActions(),
              const SizedBox(height: 28),
              const AppText.title('Recent activity'),
              const SizedBox(height: 14),
              const _ActivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.initials, required this.onSignOut});

  final String initials;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.accent, AppTheme.mint],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AppText.label(
            initials,
            fontSize: 17,
            color: AppTheme.background,
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Sign out',
          onPressed: onSignOut,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}

class _AccountOverview extends StatelessWidget {
  const _AccountOverview({required this.user, required this.providerLabel});

  final AppUser user;
  final String providerLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.mint.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: AppTheme.mint,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: AppText.title('Account connected')),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.mint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const AppText.caption(
                  'ACTIVE',
                  color: AppTheme.mint,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            color: AppTheme.muted(context).withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 16),
          _InfoLine(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: user.email,
          ),
          const SizedBox(height: 12),
          _InfoLine(
            icon: Icons.key_outlined,
            label: 'Sign-in method',
            value: providerLabel,
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.muted(context)),
        const SizedBox(width: 10),
        AppText.caption('$label  ', color: AppTheme.muted(context)),
        Expanded(
          child: AppText.body(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.security_outlined,
            label: 'Security',
            color: AppTheme.mint,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 18),
          AppText.label(label),
          const SizedBox(height: 4),
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: AppTheme.muted(context),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.login_rounded, color: AppTheme.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText.label('Signed in successfully'),
                const SizedBox(height: 4),
                AppText.caption(
                  'Your account is ready to use.',
                  color: AppTheme.muted(context),
                ),
              ],
            ),
          ),
          AppText.caption('Now', color: AppTheme.muted(context)),
        ],
      ),
    );
  }
}
