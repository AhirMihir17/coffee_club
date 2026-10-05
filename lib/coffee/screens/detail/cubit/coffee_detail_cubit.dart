import 'package:flutter_bloc/flutter_bloc.dart';
import 'coffee_detail_state.dart';

class CoffeeDetailCubit extends Cubit<CoffeeDetailState> {
  CoffeeDetailCubit({String initialSize = 'M'})
      : super(CoffeeDetailSuccess(selectedSize: initialSize));

  void setSize(String size) {
    emit(CoffeeDetailUpdated(
      selectedSize: size,
      selectedMilk: state.selectedMilk,
      selectedIce: state.selectedIce,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void setMilk(String milk) {
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: milk,
      selectedIce: state.selectedIce,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void setIce(String ice) {
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: state.selectedMilk,
      selectedIce: ice,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void setSweetness(String sweetness) {
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: state.selectedMilk,
      selectedIce: state.selectedIce,
      selectedSweetness: sweetness,
      quantity: state.quantity,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void incrementQuantity() {
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: state.selectedMilk,
      selectedIce: state.selectedIce,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity + 1,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: state.selectedMilk,
      selectedIce: state.selectedIce,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity - 1,
      isDescriptionExpanded: state.isDescriptionExpanded,
    ));
  }

  void toggleDescription() {
    emit(CoffeeDetailUpdated(
      selectedSize: state.selectedSize,
      selectedMilk: state.selectedMilk,
      selectedIce: state.selectedIce,
      selectedSweetness: state.selectedSweetness,
      quantity: state.quantity,
      isDescriptionExpanded: !state.isDescriptionExpanded,
    ));
  }
}
