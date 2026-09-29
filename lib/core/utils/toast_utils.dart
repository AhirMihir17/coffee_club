import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../widgets/app_text.dart';

class AppToast {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      onTap: onTap,
      duration: duration,
      alignment: alignment,
      type: ToastificationType.success,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      onTap: onTap,
      duration: duration,
      alignment: alignment,
      type: ToastificationType.error,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required ToastificationType type,
    required Alignment alignment,
    String? title,
    VoidCallback? onTap,
    required Duration duration,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: title != null ? AppText.label(title) : null,
      description: AppText(message),
      autoCloseDuration: duration,
      alignment: alignment,
      dragToClose: true,
      dismissDirection: alignment.y < 0
          ? DismissDirection.up
          : DismissDirection.down,
      callbacks: ToastificationCallbacks(
        onTap: onTap != null ? (_) => onTap() : null,
      ),
    );
  }
}
