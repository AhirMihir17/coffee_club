import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_text.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.color,
    this.borderColor,
    this.boxShadow,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardContent = Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (isDark ? Colors.white.withValues(alpha: 0.05) : colors.surface),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ??
              (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFDCE1ED)),
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    return cardContent;
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
