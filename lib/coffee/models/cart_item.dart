import 'package:equatable/equatable.dart';
import 'coffee_item.dart';

class CartItem extends Equatable {
  final String id;
  final CoffeeItem coffee;
  final String size;
  final String milk;
  final String ice;
  final String sweetness;
  final int quantity;

  const CartItem({
    required this.id,
    required this.coffee,
    this.size = 'M',
    this.milk = 'Whole Milk',
    this.ice = 'Hot',
    this.sweetness = 'Regular',
    this.quantity = 1,
  });

  double get unitPrice => coffee.priceForSize(size);

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? id,
    CoffeeItem? coffee,
    String? size,
    String? milk,
    String? ice,
    String? sweetness,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      coffee: coffee ?? this.coffee,
      size: size ?? this.size,
      milk: milk ?? this.milk,
      ice: ice ?? this.ice,
      sweetness: sweetness ?? this.sweetness,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        coffee,
        size,
        milk,
        ice,
        sweetness,
        quantity,
      ];
}
