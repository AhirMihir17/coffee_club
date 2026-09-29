import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_text.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = 22,
    this.strokeWidth = 2.4,
    this.color = Colors.white,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.height = 56,
  })  : _variant = _AppButtonVariant.primary,
        backgroundColor = null,
        foregroundColor = Colors.white;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.height = 52,
  })  : _variant = _AppButtonVariant.outlined,
        backgroundColor = null,
        foregroundColor = Colors.white;

  const AppButton.social({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xFF1B1B1B),
    this.height = 54,
  }) : _variant = _AppButtonVariant.social;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.foregroundColor,
    this.height = 40,
  })  : _variant = _AppButtonVariant.text,
        backgroundColor = null;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? icon;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final _AppButtonVariant _variant;

  bool get _isEnabled => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      _AppButtonVariant.primary => _PrimaryButton(
          label: label,
          onPressed: _isEnabled ? onPressed : null,
          isLoading: isLoading,
          height: height,
        ),
      _AppButtonVariant.outlined => SizedBox(
          width: double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: _isEnabled ? onPressed : null,
            child: isLoading
                ? const AppLoading()
                : AppText.label(
                    label,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ),
      _AppButtonVariant.social => SizedBox(
          height: height,
          child: ElevatedButton(
            onPressed: _isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor:
                  backgroundColor?.withValues(alpha: 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? AppLoading(color: foregroundColor ?? Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 10),
                      ],
                      AppText(
                        label,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: foregroundColor,
                      ),
                    ],
                  ),
          ),
        ),
      _AppButtonVariant.text => TextButton(
          onPressed: _isEnabled ? onPressed : null,
          child: AppText(
            label,
            color: foregroundColor ?? Colors.white.withValues(alpha: 0.72),
            fontWeight: FontWeight.w500,
          ),
        ),
    };
  }
}

enum _AppButtonVariant { primary, outlined, social, text }

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    required this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: enabled
                ? const [AppTheme.accent, Color(0xFF5B6CFF)]
                : [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.12),
                  ],
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const AppLoading()
              : AppText(
                  label,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
