import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../models/coffee_item.dart';
import '../../screens/home/cubit/home_cubit.dart';
import 'add_coffee_state.dart';

class AddCoffeeCubit extends Cubit<AddCoffeeState> {
  AddCoffeeCubit() : super(const AddCoffeeState());

  void updateName(String val) =>
      emit(state.copyWith(name: val, errorMessage: null));

  void updateSubtitle(String val) => emit(state.copyWith(subtitle: val));

  void updateCategory(String val) => emit(state.copyWith(category: val));

  void updateDescription(String val) =>
      emit(state.copyWith(description: val));

  void updatePrice(String val) =>
      emit(state.copyWith(priceText: val, errorMessage: null));

  void updateRating(String val) =>
      emit(state.copyWith(ratingText: val, errorMessage: null));

  void updateReviewCount(String val) =>
      emit(state.copyWith(reviewCountText: val));

  void updateCalories(String val) =>
      emit(state.copyWith(caloriesText: val));

  void updateStock(String val) => emit(state.copyWith(stockText: val));

  void updateRoastLevel(String val) =>
      emit(state.copyWith(roastLevel: val));

  void togglePopular(bool val) => emit(state.copyWith(isPopular: val));

  void clearError() => emit(state.copyWith(errorMessage: null));

  Future<void> submit(HomeCubit homeCubit) async {
    final name = state.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter a coffee name'));
      return;
    }

    final price = double.tryParse(state.priceText.trim());
    if (price == null) {
      emit(state.copyWith(
          errorMessage: 'Please enter a valid price (e.g. 4.50)'));
      return;
    }

    final rating = double.tryParse(state.ratingText.trim());
    if (rating == null) {
      emit(state.copyWith(
          errorMessage: 'Please enter a valid rating (e.g. 4.8)'));
      return;
    }

    final reviewCount =
        int.tryParse(state.reviewCountText.trim()) ?? 100;
    final calories = int.tryParse(state.caloriesText.trim()) ?? 180;
    final stock = int.tryParse(state.stockText.trim()) ?? 50;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final id =
          name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

      final newCoffee = CoffeeItem(
        id: id,
        name: name,
        category: state.category,
        subtitle: state.subtitle.trim().isNotEmpty
            ? state.subtitle.trim()
            : 'Artisanal Specialty',
        description: state.description.trim().isNotEmpty
            ? state.description.trim()
            : 'Carefully brewed with high-grade roasted beans for optimum flavor notes.',
        price: price,
        rating: rating,
        reviewCount: reviewCount,
        image: AppImages.imgCappuccino,
        roastLevel: state.roastLevel,
        isPopular: state.isPopular,
        sizes: const ['S', 'M', 'L'],
        sizePriceOffsets: const {'S': -0.40, 'M': 0.0, 'L': 0.60},
        stock: stock,
        calories: calories,
        createdAt: DateTime.now(),
      );

      await homeCubit.addCoffee(newCoffee);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Failed to store coffee: $e'));
    }
  }
}
