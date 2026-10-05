import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../coffee/screens/main/coffee_main_screen.dart';
import '../../core/constants/images.dart';
import '../../core/model/user_model.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/widgets/app_text.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final Duration minimumDuration;
  final bool autoNavigate;

  const SplashScreen({
    super.key,
    this.minimumDuration = const Duration(milliseconds: 2600),
    this.autoNavigate = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _entranceController.forward();

    if (widget.autoNavigate) {
      _startAuthAndNavigation();
    }
  }

  Future<void> _startAuthAndNavigation() async {
    final startTime = DateTime.now();

    Widget destination;
    try {
      final user = await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => FirebaseAuth.instance.currentUser,
          );

      if (user != null) {
        destination = CoffeeMainScreen(user: AppUser.fromFirebaseUser(user));
      } else {
        destination = const LoginScreen();
      }
    } catch (_) {
      destination = const LoginScreen();
    }

    final elapsed = DateTime.now().difference(startTime);
    final remaining = widget.minimumDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (!mounted) return;

    AppNavigator.pushFadeReplacement(context, destination);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120B08),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient Background Gradients
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A100B),
                    Color(0xFF120B08),
                    Color(0xFF0A0604),
                  ],
                ),
              ),
            ),
          ),

          // 2. Centered Warm Radial Light Aura directly behind logo
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 380 * _pulseAnimation.value,
                  height: 380 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFE8B964).withValues(alpha: 0.18),
                        const Color(0xFFC67C4E).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Perfectly Centered Content (Logo + Title + Subtitle + Loader)
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animated Logo with glowing halo
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    // Outer soft amber glow
                                    BoxShadow(
                                      color: const Color(0xFFC67C4E)
                                          .withValues(alpha: 0.32 * _pulseAnimation.value),
                                      blurRadius: 42,
                                      spreadRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                    // Golden highlight ring
                                    BoxShadow(
                                      color: const Color(0xFFFCE1A8)
                                          .withValues(alpha: 0.18 * _pulseAnimation.value),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: child,
                              );
                            },
                            child: ClipOval(
                              child: Image.asset(
                                AppImages.pngAppLogo,
                                width: 200,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Animated Brand Typography & Info
                      SlideTransition(
                        position: _contentSlide,
                        child: FadeTransition(
                          opacity: _contentFade,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Brand Title
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color(0xFFFFF8E8),
                                      Color(0xFFFCE1A8),
                                      Color(0xFFE8B964),
                                      Color(0xFFD48B5A),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  'THE COFFEE LAB',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 6.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Ornamental filigree line
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 1,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Color(0xFFE8B964),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(
                                      Icons.diamond_rounded,
                                      size: 10,
                                      color: Color(0xFFFCE1A8),
                                    ),
                                  ),
                                  Container(
                                    width: 44,
                                    height: 1,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFE8B964),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Subtitle
                              const Text(
                                'SPECIALTY BEANS & ARTISANAL BREW',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 3.2,
                                  color: Color(0xFFD48B5A),
                                ),
                              ),

                              const SizedBox(height: 36),

                              // Sleek centered loader
                              SizedBox(
                                width: 140,
                                height: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const LinearProgressIndicator(
                                    backgroundColor: Color(0xFF261913),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFC67C4E),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              const AppText(
                                'Brewing your experience...',
                                textAlign: TextAlign.center,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                                color: Color(0xFFA59B93),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Subtle bottom footnote
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: SlideTransition(
                position: _contentSlide,
                child: FadeTransition(
                  opacity: _contentFade,
                  child: const Center(
                    child: AppText(
                      'Crafted for Coffee Lovers • v1.0.0',
                      textAlign: TextAlign.center,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: Color(0xFF5E4F47),
                    ),
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
