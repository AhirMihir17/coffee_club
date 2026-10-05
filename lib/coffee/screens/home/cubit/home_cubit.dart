import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/coffee_item.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial()) {
    loadCoffees();
  }

  void loadCoffees() {
    emit(const HomeLoading());
    try {
      emit(const HomeSuccess(
        allCoffees: CoffeeRepository.sampleCoffees,
        categories: CoffeeRepository.categories,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
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
}
