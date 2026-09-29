import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/model/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';
import 'widgets/auth_background.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final user = await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => FirebaseAuth.instance.currentUser,
          );

      if (!mounted) return;

      if (user != null) {
        final appUser = AppUser.fromFirebaseUser(user);
        AppNavigator.pushReplacement(
          context,
          HomeScreen(user: appUser),
        );
      } else {
        AppNavigator.pushReplacement(
          context,
          const LoginScreen(),
        );
      }
    } catch (_) {
      if (!mounted) return;
      AppNavigator.pushReplacement(
        context,
        const LoginScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [AppTheme.accent, AppTheme.mint],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
