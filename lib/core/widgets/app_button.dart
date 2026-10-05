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
    this.width,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderRadius,
    this.padding,
  })  : _variant = _AppButtonVariant.primary,
        borderColor = null;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.height = 52,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  })  : _variant = _AppButtonVariant.outlined;

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
    this.width,
    this.borderRadius,
    this.padding,
  })  : _variant = _AppButtonVariant.social,
        borderColor = null;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.foregroundColor,
    this.height = 40,
    this.width,
    this.padding,
  })  : _variant = _AppButtonVariant.text,
        backgroundColor = null,
        borderColor = null,
        borderRadius = null;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? icon;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
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
          width: width,
          icon: icon,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          borderRadius: borderRadius,
          padding: padding,
        ),
      _AppButtonVariant.outlined => SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: _isEnabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor ?? AppTheme.primaryCoffee,
              side: BorderSide(
                color: borderColor ?? AppTheme.primaryCoffee,
                width: 1.5,
              ),
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const AppLoading()
                : (icon != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon!,
                          const SizedBox(width: 8),
                          Flexible(
                            child: AppText.label(
                              label,
                              fontWeight: FontWeight.w600,
                              color: foregroundColor ?? AppTheme.primaryCoffee,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : AppText.label(
                        label,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor ?? AppTheme.primaryCoffee,
                      )),
          ),
        ),
      _AppButtonVariant.social => SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: _isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor:
                  backgroundColor?.withValues(alpha: 0.7),
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(16),
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
                      Flexible(
                        child: AppText(
                          label,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: foregroundColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      _AppButtonVariant.text => SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: _isEnabled ? onPressed : null,
            style: TextButton.styleFrom(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 6),
                ],
                AppText(
                  label,
                  fontSize: 12.5,
                  color: foregroundColor ?? AppTheme.primaryCoffee,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
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
    this.width,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final rRadius = borderRadius ?? BorderRadius.circular(16);

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: rRadius,
          gradient: backgroundColor == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: enabled
                      ? const [
                          Color(0xFFC67C4E),
                          Color(0xFFA25B2C),
                        ]
                      : const [
                          Color(0xFFB8784E),
                          Color(0xFF8F5128),
                        ],
                )
              : null,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? const Color(0xFFC67C4E))
                  .withValues(alpha: enabled ? 0.35 : 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: foregroundColor ?? Colors.white,
            disabledForegroundColor: (foregroundColor ?? Colors.white).withValues(alpha: 0.8),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: rRadius,
            ),
          ),
          child: isLoading
              ? AppLoading(color: foregroundColor ?? Colors.white)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: AppText(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: foregroundColor ?? Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
