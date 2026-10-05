import '../../../models/coffee_item.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesSuccess extends FavoritesState {
  final Set<String> favoriteIds;
  final List<CoffeeItem> allCoffees;

  const FavoritesSuccess({
    this.favoriteIds = const {'caramel_macchiato', 'classic_cappuccino'},
    this.allCoffees = CoffeeRepository.sampleCoffees,
  });

  List<CoffeeItem> get favoriteCoffees =>
      allCoffees.where((c) => favoriteIds.contains(c.id)).toList();

  bool isFav(String id) => favoriteIds.contains(id);

  FavoritesSuccess copyWith({
    Set<String>? favoriteIds,
    List<CoffeeItem>? allCoffees,
  }) {
    return FavoritesSuccess(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      allCoffees: allCoffees ?? this.allCoffees,
    );
  }
}

// Backward compatibility alias
typedef FavoritesLoaded = FavoritesSuccess;

class FavoritesError extends FavoritesState {
  final String errorMessage;

  const FavoritesError(this.errorMessage);
}
