import '../../../models/coffee_item.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  final List<CoffeeItem> allCoffees;
  final String selectedCategory;
  final String searchQuery;
  final String selectedRoast;
  final List<String> categories;
  final bool isSyncing;
  final String? statusMessage;
  final bool isLiveFirestore;

  final Set<String> expandedDocIds;

  const HomeSuccess({
    this.allCoffees = CoffeeRepository.sampleCoffees,
    this.selectedCategory = 'All Coffee',
    this.searchQuery = '',
    this.selectedRoast = 'All Roasts',
    this.categories = CoffeeRepository.categories,
    this.isSyncing = false,
    this.statusMessage,
    this.isLiveFirestore = true,
    this.expandedDocIds = const <String>{},
  });

  List<CoffeeItem> get filteredCoffees {
    return allCoffees.where((coffee) {
      final matchesCategory = selectedCategory == 'All Coffee' ||
          coffee.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesRoast = selectedRoast == 'All Roasts' ||
          coffee.roastLevel.toLowerCase().contains(selectedRoast.toLowerCase());
      final matchesQuery = searchQuery.isEmpty ||
          coffee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          coffee.subtitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
          coffee.category.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesRoast && matchesQuery;
    }).toList();
  }

  HomeSuccess copyWith({
    List<CoffeeItem>? allCoffees,
    String? selectedCategory,
    String? searchQuery,
    String? selectedRoast,
    List<String>? categories,
    bool? isSyncing,
    String? statusMessage,
    bool? isLiveFirestore,
    Set<String>? expandedDocIds,
  }) {
    return HomeSuccess(
      allCoffees: allCoffees ?? this.allCoffees,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRoast: selectedRoast ?? this.selectedRoast,
      categories: categories ?? this.categories,
      isSyncing: isSyncing ?? this.isSyncing,
      statusMessage: statusMessage ?? this.statusMessage,
      isLiveFirestore: isLiveFirestore ?? this.isLiveFirestore,
      expandedDocIds: expandedDocIds ?? this.expandedDocIds,
    );
  }
}

// Backward compatibility alias
typedef HomeLoaded = HomeSuccess;

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError(this.errorMessage);
}
