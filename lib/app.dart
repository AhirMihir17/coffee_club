import 'package:firebase_learning/core/repository/auth_repository.dart';
import 'package:firebase_learning/core/repository/signup_repository.dart';
import 'package:firebase_learning/core/repository/forgot_password_repository.dart';
import 'package:firebase_learning/core/theme/theme_cubit.dart';
import 'package:firebase_learning/screens/auth/cubit/forgot_password_cubit.dart';
import 'package:firebase_learning/screens/auth/cubit/login_cubit.dart';
import 'package:firebase_learning/screens/auth/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/app_theme.dart';
import 'core/service/firebase_auth_service.dart';
import 'screens/auth/auth_gate.dart';

class FirebaseLearningApp extends StatelessWidget {
  const FirebaseLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(AuthRepository(authService)),
        ),
        BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(SignupRepository(authService)),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (_) =>
              ForgotPasswordCubit(ForgotPasswordRepository(authService)),
        ),
      ],
      child: ToastificationWrapper(
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Firebase Learning',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }
}
