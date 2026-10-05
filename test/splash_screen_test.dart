import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_club/core/constants/images.dart';
import 'package:coffee_club/screens/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays logo, title, and loading indicator cleanly',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(
          minimumDuration: Duration(milliseconds: 100),
          autoNavigate: false, // Don't trigger navigation in unit test
        ),
      ),
    );

    // Initial frame
    await tester.pump();
    expect(tester.takeException(), isNull);

    // Verify title and subtitle exist in widget tree
    expect(find.text('THE COFFEE LAB'), findsOneWidget);
    expect(find.text('SPECIALTY BEANS & ARTISANAL BREW'), findsOneWidget);
    expect(find.text('Brewing your experience...'), findsOneWidget);

    // Verify logo image asset
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsWidgets);

    final imageWidget = tester.firstWidget<Image>(imageFinder);
    expect((imageWidget.image as AssetImage).assetName, equals(AppImages.pngAppLogo));

    // Advance animation
    await tester.pump(const Duration(milliseconds: 1500));
    expect(tester.takeException(), isNull);
  });
}
