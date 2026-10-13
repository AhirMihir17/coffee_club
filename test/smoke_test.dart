import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_club/core/theme/app_theme.dart';
import 'package:coffee_club/core/model/user_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('AppUser model instantiates correctly', () {
    const user = AppUser(
      id: 'test_uid',
      displayName: 'Test User',
      email: 'test@example.com',
      provider: AuthProviderType.email,
    );

    expect(user.id, equals('test_uid'));
    expect(user.displayName, equals('Test User'));
    expect(user.email, equals('test@example.com'));
    expect(user.provider, equals(AuthProviderType.email));
  });

  test('AppTheme loads light and dark themes properly', () {
    final lightTheme = AppTheme.light();
    final darkTheme = AppTheme.dark();

    expect(lightTheme.brightness, equals(Brightness.light));
    expect(darkTheme.brightness, equals(Brightness.dark));
  });
}
