import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF0A1024),
                      Color(0xFF101A38),
                      Color(0xFF071018),
                    ]
                  : const [
                      Color(0xFFF5F7FC),
                      Color(0xFFE9EDFA),
                      Color(0xFFF8FAFF),
                    ],
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _GlowOrb(
            size: 260,
            color: AppTheme.accent.withValues(alpha: isDark ? 0.28 : 0.12),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -70,
          child: _GlowOrb(
            size: 220,
            color: AppTheme.mint.withValues(alpha: isDark ? 0.18 : 0.1),
          ),
        ),
        Positioned(
          top: 180,
          left: 40,
          child: _GlowOrb(
            size: 90,
            color: const Color(0xFFFF8A65).withValues(alpha: 0.1),
          ),
        ),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 20)],
      ),
    );
  }
}
