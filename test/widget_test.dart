import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_learning/app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Login screen shows auth options', (WidgetTester tester) async {
    await tester.pumpWidget(const FirebaseLearningApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Play Games'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
