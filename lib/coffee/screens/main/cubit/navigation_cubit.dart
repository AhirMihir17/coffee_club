import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationInitial(0));

  void setTab(int index) {
    if (state.selectedIndex != index) {
      emit(NavigationTabChanged(index));
    }
  }
}
