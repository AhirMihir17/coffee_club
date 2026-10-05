import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/cart_item.dart';
import '../../../models/coffee_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial()) {
    initCart();
  }

  void initCart() {
    emit(const CartLoading());
    try {
      emit(const CartSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  CartSuccess get _currentSuccess {
    if (state is CartSuccess) {
      return state as CartSuccess;
    }
    return const CartSuccess();
  }

  void addToCart(
    CoffeeItem coffee, {
    String size = 'M',
    String milk = 'Whole Milk',
    int quantity = 1,
    String ice = 'Hot',
    String sweetness = 'Regular',
  }) {
    try {
      final current = _currentSuccess;
      final existingIndex = current.cartItems.indexWhere(
        (item) =>
            item.coffee.id == coffee.id &&
            item.size == size &&
            item.milk == milk,
      );

      List<CartItem> updated;
      if (existingIndex >= 0) {
        updated = List<CartItem>.from(current.cartItems);
        final existing = updated[existingIndex];
        updated[existingIndex] =
            existing.copyWith(quantity: existing.quantity + quantity);
      } else {
        final newItem = CartItem(
          id: '${coffee.id}_${size}_${milk}_${DateTime.now().millisecondsSinceEpoch}',
          coffee: coffee,
          size: size,
          milk: milk,
          ice: ice,
          sweetness: sweetness,
          quantity: quantity,
        );
        updated = [...current.cartItems, newItem];
      }

      emit(current.copyWith(cartItems: updated));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void incrementQuantity(String itemId) {
    try {
      final current = _currentSuccess;
      final updated = current.cartItems.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      emit(current.copyWith(cartItems: updated));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void decrementQuantity(String itemId) {
    try {
      final current = _currentSuccess;
      final List<CartItem> updated = [];
      for (final item in current.cartItems) {
        if (item.id == itemId) {
          if (item.quantity > 1) {
            updated.add(item.copyWith(quantity: item.quantity - 1));
          }
        } else {
          updated.add(item);
        }
      }

      emit(current.copyWith(cartItems: updated));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void removeFromCart(String itemId) {
    try {
      final current = _currentSuccess;
      final updated = current.cartItems.where((i) => i.id != itemId).toList();
      emit(current.copyWith(cartItems: updated));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void setDelivery(bool isDelivery) {
    try {
      final current = _currentSuccess;
      emit(current.copyWith(isDelivery: isDelivery));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void updateAddress(String address) {
    try {
      final current = _currentSuccess;
      emit(current.copyWith(deliveryAddress: address));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  bool applyPromo(String code) {
    try {
      final current = _currentSuccess;
      final trimmed = code.trim().toUpperCase();
      if (trimmed == 'COFFEE20') {
        emit(current.copyWith(
          promoCode: 'COFFEE20',
          discountRate: 0.20,
        ));
        return true;
      }
      return false;
    } catch (e) {
      emit(CartError(e.toString()));
      return false;
    }
  }

  void removePromo() {
    try {
      final current = _currentSuccess;
      emit(CartSuccess(
        cartItems: current.cartItems,
        isDelivery: current.isDelivery,
        deliveryAddress: current.deliveryAddress,
        promoCode: null,
        discountRate: 0.0,
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void placeOrder() {
    try {
      final current = _currentSuccess;
      if (current.cartItems.isEmpty) return;
      emit(const CartOrderSuccessState());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void resetStatus() {
    emit(const CartSuccess());
  }
}
