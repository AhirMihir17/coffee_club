import 'package:coffee_club/core/repository/auth_repository.dart';
import 'package:coffee_club/core/repository/signup_repository.dart';
import 'package:coffee_club/core/repository/forgot_password_repository.dart';
import 'package:coffee_club/core/theme/theme_cubit.dart';
import 'package:coffee_club/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:coffee_club/screens/login/cubit/login_cubit.dart';
import 'package:coffee_club/screens/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'coffee/cubit/coffee_cubit.dart';
import 'coffee/screens/home/cubit/home_cubit.dart';
import 'coffee/screens/cart/cubit/cart_cubit.dart';
import 'coffee/screens/favorites/cubit/favorites_cubit.dart';
import 'coffee/screens/main/cubit/navigation_cubit.dart';
import 'coffee/screens/profile/cubit/profile_cubit.dart';
import 'core/constants/strings.dart';
import 'core/service/firebase_auth_service.dart';
import 'core/service/firestore_service.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class CoffeeClubApp extends StatelessWidget {
  const CoffeeClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    final firestoreService = FirestoreService();

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
        BlocProvider<CoffeeCubit>(
          create: (_) => CoffeeCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(firestoreService: firestoreService),
        ),
        BlocProvider<CartCubit>(
          create: (_) => CartCubit(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(firestoreService: firestoreService),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(),
        ),
      ],
      child: ToastificationWrapper(
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
