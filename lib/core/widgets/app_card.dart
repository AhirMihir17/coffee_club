import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_text.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : colors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFDCE1ED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppOrDivider extends StatelessWidget {
  const AppOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = AppTheme.muted(context);

    return Row(
      children: [
        Expanded(
          child: Divider(color: muted.withValues(alpha: 0.28)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: AppText.caption(
            label,
            color: muted,
          ),
        ),
        Expanded(
          child: Divider(color: muted.withValues(alpha: 0.28)),
        ),
      ],
    );
  }
}
