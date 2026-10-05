import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/coffee_item.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial()) {
    loadFavorites();
  }

  void loadFavorites() {
    emit(const FavoritesLoading());
    try {
      emit(const FavoritesSuccess());
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void toggleFavorite(String coffeeId) {
    try {
      final currentIds = state is FavoritesSuccess
          ? (state as FavoritesSuccess).favoriteIds
          : const <String>{'caramel_macchiato', 'classic_cappuccino'};
      final updated = Set<String>.from(currentIds);
      if (updated.contains(coffeeId)) {
        updated.remove(coffeeId);
      } else {
        updated.add(coffeeId);
      }
      final coffees = state is FavoritesSuccess
          ? (state as FavoritesSuccess).allCoffees
          : CoffeeRepository.sampleCoffees;

      emit(FavoritesSuccess(
        favoriteIds: updated,
        allCoffees: coffees,
      ));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void clearFavorites() {
    final coffees = state is FavoritesSuccess
        ? (state as FavoritesSuccess).allCoffees
        : CoffeeRepository.sampleCoffees;
    emit(FavoritesSuccess(
      favoriteIds: const {},
      allCoffees: coffees,
    ));
  }
}
