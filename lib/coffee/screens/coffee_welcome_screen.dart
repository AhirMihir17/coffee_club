import 'package:flutter/material.dart';
import '../../core/constants/images.dart';
import '../../core/constants/strings.dart';
import '../../core/model/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/widgets/app_widgets.dart';
import 'main/coffee_main_screen.dart';

class CoffeeWelcomeScreen extends StatelessWidget {
  final AppUser? user;

  const CoffeeWelcomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Hero Background Image (top 65%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.65,
            child: const CustomCachedImage(
              imageUrl: AppImages.imgHeroCoffee,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay covering transition from image to black bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.62, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Content at bottom
          Positioned(
            left: 28,
            right: 28,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  AppStrings.welcomeHeroTitle,
                  textAlign: TextAlign.center,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const AppText(
                  AppStrings.welcomeHeroSubtitle,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFFA59B93),
                ),
                const SizedBox(height: 32),
                AppButton.primary(
                  label: AppStrings.getStarted,
                  height: 56,
                  borderRadius: BorderRadius.circular(18),
                  onPressed: () {
                    AppNavigator.pushAndRemoveUntil(
                      context,
                      CoffeeMainScreen(user: user),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
