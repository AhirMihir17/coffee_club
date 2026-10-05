import 'package:flutter/material.dart';
import '../constants/images.dart';
import '../theme/app_theme.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final bool showImage;

  const AuthBackground({
    super.key,
    required this.child,
    this.backgroundImage = AppImages.imgHeroCoffee,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base dark coffee background
        Container(
          color: isDark ? const Color(0xFF0F0B08) : const Color(0xFFF9F5F0),
        ),

        // Atmospheric Coffee Background Image
        if (showImage && backgroundImage != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Opacity(
              opacity: isDark ? 0.35 : 0.22,
              child: Image.asset(
                backgroundImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),

        // Rich Coffee Gradient Overlays
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.75, 1.0],
              colors: isDark
                  ? const [
                      Color(0xCC1A120D), // Semi-translucent roasted brown
                      Color(0xF0140D09),
                      Color(0xFC0F0B08),
                      Color(0xFF0A0705), // Deep espresso black bottom
                    ]
                  : const [
                      Color(0xDDF9F3EB), // Warm latte froth
                      Color(0xF2F5EBE1),
                      Color(0xFCF2E6DC),
                      Color(0xFFEDE0D4),
                    ],
            ),
          ),
          child: const SizedBox.expand(),
        ),

        // Ambient Warm Coffee Glow Orbs
        Positioned(
          top: -60,
          right: -40,
          child: _GlowOrb(
            size: 260,
            color: AppTheme.primaryCoffee.withValues(alpha: isDark ? 0.35 : 0.20),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -70,
          child: _GlowOrb(
            size: 240,
            color: const Color(0xFF8D4E28).withValues(alpha: isDark ? 0.28 : 0.15),
          ),
        ),
        Positioned(
          top: 240,
          left: 20,
          child: _GlowOrb(
            size: 130,
            color: const Color(0xFFD4A373).withValues(alpha: isDark ? 0.18 : 0.12),
          ),
        ),

        // Child Content
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 90,
            spreadRadius: 25,
          ),
        ],
      ),
    );
  }
}
