import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_club/coffee/screens/home/coffee_home_tab.dart';
import 'package:coffee_club/coffee/screens/home/cubit/home_cubit.dart';
import 'package:coffee_club/coffee/screens/favorites/cubit/favorites_cubit.dart';
import 'package:coffee_club/core/constants/strings.dart';
import 'package:coffee_club/core/theme/app_theme.dart';
import 'package:coffee_club/core/widgets/app_text_field.dart';

void main() {
  testWidgets('Empty search state renders cleanly without overflow on constrained height', (tester) async {
    final homeCubit = HomeCubit();
    final favoritesCubit = FavoritesCubit();

    // Set search query for non-existent item
    homeCubit.setSearchQuery('NonExistentCoffeeXYZ');

    // Simulate small constrained mobile screen height (e.g. 500px, as when keyboard is open)
    tester.view.physicalSize = const Size(360, 520);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<FavoritesCubit>.value(value: favoritesCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const CoffeeHomeTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.noCoffeeFound), findsOneWidget);
    expect(find.text(AppStrings.noCoffeeFoundSubtitle), findsOneWidget);
    expect(find.text('Clear Search'), findsOneWidget);
  });

  testWidgets('Search field text color is dark in light theme', (tester) async {
    final homeCubit = HomeCubit();
    final favoritesCubit = FavoritesCubit();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<FavoritesCubit>.value(value: favoritesCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const CoffeeHomeTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final appTextFieldFinder = find.byType(AppTextField);
    expect(appTextFieldFinder, findsOneWidget);

    final appTextField = tester.widget<AppTextField>(appTextFieldFinder);
    expect(appTextField.style?.color, equals(const Color(0xFF241913)));
  });

  testWidgets('Search field text color is white in dark theme', (tester) async {
    final homeCubit = HomeCubit();
    final favoritesCubit = FavoritesCubit();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<FavoritesCubit>.value(value: favoritesCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const CoffeeHomeTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final appTextFieldFinder = find.byType(AppTextField);
    expect(appTextFieldFinder, findsOneWidget);

    final appTextField = tester.widget<AppTextField>(appTextFieldFinder);
    expect(appTextField.style?.color, equals(Colors.white));
  });
}
