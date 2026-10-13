import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/firestore_service.dart';
import '../../../models/coffee_item.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirestoreService _firestoreService;
  StreamSubscription<List<CoffeeItem>>? _coffeeSubscription;

  HomeCubit({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService(),
        super(const HomeInitial()) {
    loadCoffees();
  }

  void loadCoffees() {
    emit(const HomeLoading());
    _coffeeSubscription?.cancel();

    if (!_firestoreService.isFirebaseAvailable) {
      emit(const HomeSuccess(
        allCoffees: CoffeeRepository.sampleCoffees,
        categories: CoffeeRepository.categories,
        isLiveFirestore: false,
        statusMessage: 'Default local data',
      ));
      return;
    }

    _coffeeSubscription = _firestoreService.getCoffeesStream().listen(
      (coffees) {
        if (coffees.isEmpty) {
          // If Firestore is empty, auto-seed with sample coffees
          _firestoreService.seedInitialCoffees().catchError((e) {
            // Seeding error handled silently or in stream error
          });
          return;
        }

        final dynamicCategories = <String>{'All Coffee'};
        for (final item in coffees) {
          if (item.category.trim().isNotEmpty) {
            dynamicCategories.add(item.category.trim());
          }
        }

        final current = state;
        final selectedCat = current is HomeSuccess ? current.selectedCategory : 'All Coffee';
        final query = current is HomeSuccess ? current.searchQuery : '';
        final selectedRoast = current is HomeSuccess ? current.selectedRoast : 'All Roasts';

        emit(HomeSuccess(
          allCoffees: coffees,
          categories: dynamicCategories.toList(),
          selectedCategory: dynamicCategories.contains(selectedCat) ? selectedCat : 'All Coffee',
          searchQuery: query,
          selectedRoast: selectedRoast,
          isLiveFirestore: true,
          statusMessage: 'Live Cloud Firestore (${coffees.length} items)',
        ));
      },
      onError: (error) {
        final current = state;
        final selectedCat = current is HomeSuccess ? current.selectedCategory : 'All Coffee';
        final query = current is HomeSuccess ? current.searchQuery : '';

        emit(HomeSuccess(
          allCoffees: CoffeeRepository.sampleCoffees,
          categories: CoffeeRepository.categories,
          selectedCategory: selectedCat,
          searchQuery: query,
          isLiveFirestore: false,
          statusMessage: 'Firestore stream error: $error',
        ));
      },
    );
  }

  Future<void> seedDataToFirestore() async {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(isSyncing: true, statusMessage: 'Seeding Cloud Firestore...'));
    }
    try {
      await _firestoreService.seedInitialCoffees();
      if (state is HomeSuccess) {
        final current = state as HomeSuccess;
        emit(current.copyWith(
          isSyncing: false,
          statusMessage: 'Firestore seeded successfully!',
        ));
      }
    } catch (e) {
      if (state is HomeSuccess) {
        final current = state as HomeSuccess;
        emit(current.copyWith(
          isSyncing: false,
          statusMessage: 'Seed failed: $e',
        ));
      }
    }
  }

  Future<void> addCoffee(CoffeeItem item) async {
    try {
      await _firestoreService.saveCoffee(item);
    } catch (e) {
      if (state is HomeSuccess) {
        final current = state as HomeSuccess;
        emit(current.copyWith(statusMessage: 'Failed to add coffee: $e'));
      }
    }
  }

  Future<void> deleteCoffee(String id) async {
    try {
      await _firestoreService.deleteCoffee(id);
    } catch (e) {
      if (state is HomeSuccess) {
        final current = state as HomeSuccess;
        emit(current.copyWith(statusMessage: 'Failed to delete coffee: $e'));
      }
    }
  }

  void setCategory(String category) {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(selectedCategory: category));
    } else {
      emit(HomeSuccess(selectedCategory: category));
    }
  }

  void setSearchQuery(String query) {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(searchQuery: query));
    } else {
      emit(HomeSuccess(searchQuery: query));
    }
  }

  void setRoastFilter(String roast) {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(selectedRoast: roast));
    } else {
      emit(HomeSuccess(selectedRoast: roast));
    }
  }

  void resetFilter() {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(
        selectedCategory: 'All Coffee',
        searchQuery: '',
        selectedRoast: 'All Roasts',
      ));
    } else {
      emit(const HomeSuccess());
    }
  }

  void clearSearch() {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      emit(current.copyWith(searchQuery: '', selectedCategory: 'All Coffee'));
    } else {
      emit(const HomeSuccess());
    }
  }

  void toggleDocExpanded(String docId) {
    if (state is HomeSuccess) {
      final current = state as HomeSuccess;
      final next = Set<String>.from(current.expandedDocIds);
      if (next.contains(docId)) {
        next.remove(docId);
      } else {
        next.add(docId);
      }
      emit(current.copyWith(expandedDocIds: next));
    }
  }

  @override
  Future<void> close() {
    _coffeeSubscription?.cancel();
    return super.close();
  }
}
