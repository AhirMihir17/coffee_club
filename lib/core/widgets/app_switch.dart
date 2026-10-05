import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.thumbIcon,
    this.isThemeToggle = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final bool isThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor ?? AppTheme.mint,
      activeTrackColor: activeTrackColor ?? AppTheme.accent.withValues(alpha: 0.25),
      inactiveThumbColor: inactiveThumbColor ?? const Color(0xFF65708A),
      inactiveTrackColor: inactiveTrackColor ?? const Color(0xFFF0F2F8),
      thumbIcon: thumbIcon ??
          (isThemeToggle
              ? WidgetStateProperty.resolveWith<Icon?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Icon(
                      Icons.dark_mode_rounded,
                      size: 16,
                      color: Colors.white,
                    );
                  }
                  return const Icon(
                    Icons.light_mode_rounded,
                    size: 16,
                    color: Colors.white,
                  );
                })
              : null),
    );
  }
}
