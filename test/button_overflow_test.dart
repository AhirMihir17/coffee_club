import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_club/coffee/screens/favorites/coffee_favorites_tab.dart';
import 'package:coffee_club/coffee/screens/favorites/cubit/favorites_cubit.dart';
import 'package:coffee_club/core/constants/strings.dart';
import 'package:coffee_club/core/widgets/app_button.dart';

void main() {
  testWidgets('AppButton.primary with Discover Coffees renders without overflow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppButton.primary(
              label: AppStrings.discoverCoffees,
              height: 46,
              width: 200,
              borderRadius: BorderRadius.circular(14),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.discoverCoffees), findsOneWidget);
  });

  testWidgets('CoffeeFavoritesTab empty state renders Discover Coffees button without overflow', (tester) async {
    final cubit = FavoritesCubit();
    cubit.clearFavorites();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FavoritesCubit>.value(
          value: cubit,
          child: const CoffeeFavoritesTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.discoverCoffees), findsOneWidget);
    expect(find.text(AppStrings.noFavoritesTitle), findsOneWidget);
  });
}
