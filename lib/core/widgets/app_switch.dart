import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeIcon,
    this.inactiveIcon,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? activeIcon;
  final Widget? inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.mint,
      activeTrackColor: AppTheme.accent.withValues(alpha: 0.25),
      inactiveThumbColor: const Color(0xFF65708A),
      inactiveTrackColor: const Color(0xFFF0F2F8),
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
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
      }),
    );
  }
}
