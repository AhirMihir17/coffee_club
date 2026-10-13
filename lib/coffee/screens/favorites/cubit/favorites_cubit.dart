import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/firestore_service.dart';
import '../../../models/coffee_item.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirestoreService _firestoreService;
  StreamSubscription<List<CoffeeItem>>? _coffeeSubscription;

  FavoritesCubit({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService(),
        super(const FavoritesInitial()) {
    loadFavorites();
  }

  void loadFavorites() {
    emit(const FavoritesLoading());
    _coffeeSubscription?.cancel();

    if (!_firestoreService.isFirebaseAvailable) {
      emit(const FavoritesSuccess(
        favoriteIds: {'caramel_macchiato', 'classic_cappuccino'},
        allCoffees: CoffeeRepository.sampleCoffees,
      ));
      return;
    }

    _coffeeSubscription = _firestoreService.getCoffeesStream().listen(
      (coffees) {
        final currentFavs = state is FavoritesSuccess
            ? (state as FavoritesSuccess).favoriteIds
            : const <String>{'caramel_macchiato', 'classic_cappuccino'};
        emit(FavoritesSuccess(
          favoriteIds: currentFavs,
          allCoffees: coffees.isNotEmpty ? coffees : CoffeeRepository.sampleCoffees,
        ));
      },
      onError: (e) {
        emit(FavoritesSuccess(
          favoriteIds: const {'caramel_macchiato', 'classic_cappuccino'},
          allCoffees: CoffeeRepository.sampleCoffees,
        ));
      },
    );
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

  @override
  Future<void> close() {
    _coffeeSubscription?.cancel();
    return super.close();
  }
}
