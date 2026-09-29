import 'package:flutter/material.dart';

class AppNavigator {
  /// Navigates to a new screen/page.
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replaces the current screen with a new one.
  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page, {TO? result}) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Navigates to a new screen and removes previous screens based on the predicate.
  /// Defaults to removing all previous screens if no predicate is given.
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (_) => false,
    );
  }

  /// Pops the topmost screen off the navigation stack.
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Alias for pop/back navigation.
  static void back<T>(BuildContext context, [T? result]) {
    pop<T>(context, result);
  }
}
