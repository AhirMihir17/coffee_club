import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_club/coffee/widgets/cubit/add_coffee_cubit.dart';
import 'package:coffee_club/coffee/screens/home/cubit/home_cubit.dart';
import 'package:coffee_club/coffee/screens/home/cubit/home_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddCoffeeCubit Tests', () {
    test('Initial state has default values', () {
      final cubit = AddCoffeeCubit();
      expect(cubit.state.category, equals('Latte'));
      expect(cubit.state.roastLevel, equals('Medium Roast'));
      expect(cubit.state.isPopular, isTrue);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage, isNull);
    });

    test('Updating fields updates state without setState', () {
      final cubit = AddCoffeeCubit();

      cubit.updateName('Mocha Delight');
      expect(cubit.state.name, equals('Mocha Delight'));

      cubit.updateCategory('Espresso');
      expect(cubit.state.category, equals('Espresso'));

      cubit.updateRoastLevel('Dark Roast');
      expect(cubit.state.roastLevel, equals('Dark Roast'));

      cubit.togglePopular(false);
      expect(cubit.state.isPopular, isFalse);

      cubit.updatePrice('5.25');
      expect(cubit.state.priceText, equals('5.25'));

      cubit.updateRating('4.9');
      expect(cubit.state.ratingText, equals('4.9'));
    });

    test('Validation fails on empty name', () async {
      final cubit = AddCoffeeCubit();
      final homeCubit = HomeCubit();

      await cubit.submit(homeCubit);

      expect(cubit.state.errorMessage, equals('Please enter a coffee name'));
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isSuccess, isFalse);
    });

    test('Validation fails on invalid price', () async {
      final cubit = AddCoffeeCubit();
      final homeCubit = HomeCubit();

      cubit.updateName('Test Coffee');
      cubit.updatePrice('abc');

      await cubit.submit(homeCubit);

      expect(cubit.state.errorMessage, contains('valid price'));
    });

    test('Validation fails on invalid rating', () async {
      final cubit = AddCoffeeCubit();
      final homeCubit = HomeCubit();

      cubit.updateName('Test Coffee');
      cubit.updatePrice('4.50');
      cubit.updateRating('not-a-number');

      await cubit.submit(homeCubit);

      expect(cubit.state.errorMessage, contains('valid rating'));
    });
  });

  group('HomeCubit Doc Expansion Tests', () {
    test('toggleDocExpanded expands and collapses document without setState', () {
      final homeCubit = HomeCubit();

      expect(homeCubit.state, isA<HomeSuccess>());
      final initialSuccess = homeCubit.state as HomeSuccess;
      expect(initialSuccess.expandedDocIds.isEmpty, isTrue);

      homeCubit.toggleDocExpanded('caramel_macchiato');
      final expandedState = homeCubit.state as HomeSuccess;
      expect(expandedState.expandedDocIds.contains('caramel_macchiato'), isTrue);

      homeCubit.toggleDocExpanded('caramel_macchiato');
      final collapsedState = homeCubit.state as HomeSuccess;
      expect(collapsedState.expandedDocIds.contains('caramel_macchiato'), isFalse);
    });
  });
}
