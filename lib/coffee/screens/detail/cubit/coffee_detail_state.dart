abstract class CoffeeDetailState {
  const CoffeeDetailState();

  String get selectedSize => 'M';
  String get selectedMilk => 'Whole Milk';
  String get selectedIce => 'Hot';
  String get selectedSweetness => 'Regular';
  int get quantity => 1;
  bool get isDescriptionExpanded => false;
}

class CoffeeDetailInitial extends CoffeeDetailState {
  const CoffeeDetailInitial();
}

class CoffeeDetailLoading extends CoffeeDetailState {
  const CoffeeDetailLoading();
}

class CoffeeDetailSuccess extends CoffeeDetailState {
  @override
  final String selectedSize;
  @override
  final String selectedMilk;
  @override
  final String selectedIce;
  @override
  final String selectedSweetness;
  @override
  final int quantity;
  @override
  final bool isDescriptionExpanded;

  const CoffeeDetailSuccess({
    this.selectedSize = 'M',
    this.selectedMilk = 'Whole Milk',
    this.selectedIce = 'Hot',
    this.selectedSweetness = 'Regular',
    this.quantity = 1,
    this.isDescriptionExpanded = false,
  });
}

// Backward-compatibility alias
typedef CoffeeDetailUpdated = CoffeeDetailSuccess;

class CoffeeDetailError extends CoffeeDetailState {
  final String errorMessage;

  const CoffeeDetailError(this.errorMessage);
}
