import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_item.dart';
import '../models/coffee_item.dart';
import 'coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeLoaded _currentLoaded = const CoffeeLoaded();

  CoffeeCubit() : super(const CoffeeLoaded());

  CoffeeLoaded get loadedData => _currentLoaded;

  void setCategory(String category) {
    _currentLoaded = _currentLoaded.copyWith(selectedCategory: category);
    emit(_currentLoaded);
  }

  void setSearchQuery(String query) {
    _currentLoaded = _currentLoaded.copyWith(searchQuery: query);
    emit(_currentLoaded);
  }

  void toggleFavorite(String coffeeId) {
    final updatedFavorites = Set<String>.from(_currentLoaded.favoriteIds);
    if (updatedFavorites.contains(coffeeId)) {
      updatedFavorites.remove(coffeeId);
    } else {
      updatedFavorites.add(coffeeId);
    }
    _currentLoaded = _currentLoaded.copyWith(favoriteIds: updatedFavorites);
    emit(_currentLoaded);
  }

  void addToCart(
    CoffeeItem coffee, {
    String size = 'M',
    String milk = 'Whole Milk',
    String ice = 'Hot',
    String sweetness = 'Regular',
    int quantity = 1,
  }) {
    final itemId = '${coffee.id}_${size}_${milk}_${ice}_$sweetness';
    final existingIndex =
        _currentLoaded.cartItems.indexWhere((item) => item.id == itemId);

    List<CartItem> updatedList = List.from(_currentLoaded.cartItems);

    if (existingIndex >= 0) {
      final current = updatedList[existingIndex];
      updatedList[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      updatedList.add(
        CartItem(
          id: itemId,
          coffee: coffee,
          size: size,
          milk: milk,
          ice: ice,
          sweetness: sweetness,
          quantity: quantity,
        ),
      );
    }

    _currentLoaded = _currentLoaded.copyWith(
      cartItems: updatedList,
      message: 'Added ${coffee.name} to cart',
    );
    emit(_currentLoaded);
  }

  void incrementQuantity(String cartItemId) {
    final updatedList = _currentLoaded.cartItems.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    _currentLoaded = _currentLoaded.copyWith(cartItems: updatedList);
    emit(_currentLoaded);
  }

  void decrementQuantity(String cartItemId) {
    final updatedList = <CartItem>[];
    for (final item in _currentLoaded.cartItems) {
      if (item.id == cartItemId) {
        if (item.quantity > 1) {
          updatedList.add(item.copyWith(quantity: item.quantity - 1));
        }
      } else {
        updatedList.add(item);
      }
    }

    _currentLoaded = _currentLoaded.copyWith(cartItems: updatedList);
    emit(_currentLoaded);
  }

  void removeFromCart(String cartItemId) {
    final updatedList =
        _currentLoaded.cartItems.where((item) => item.id != cartItemId).toList();
    _currentLoaded = _currentLoaded.copyWith(cartItems: updatedList);
    emit(_currentLoaded);
  }

  void clearCart() {
    _currentLoaded = _currentLoaded.copyWith(cartItems: const []);
    emit(_currentLoaded);
  }

  void setDelivery(bool isDelivery) {
    _currentLoaded = _currentLoaded.copyWith(isDelivery: isDelivery);
    emit(_currentLoaded);
  }

  void updateAddress(String address) {
    _currentLoaded = _currentLoaded.copyWith(deliveryAddress: address);
    emit(_currentLoaded);
  }

  bool applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'COFFEE20' || cleanCode == 'BREW20') {
      _currentLoaded = _currentLoaded.copyWith(
        promoCode: cleanCode,
        discountRate: 0.20,
        message: '20% Discount Applied!',
      );
      emit(_currentLoaded);
      return true;
    } else if (cleanCode == 'FIRSTCUP' || cleanCode == 'WELCOME') {
      _currentLoaded = _currentLoaded.copyWith(
        promoCode: cleanCode,
        discountRate: 0.30,
        message: '30% Discount Applied!',
      );
      emit(_currentLoaded);
      return true;
    } else {
      _currentLoaded = _currentLoaded.copyWith(
        message: 'Invalid promo code. Try COFFEE20',
      );
      emit(_currentLoaded);
      return false;
    }
  }

  void removePromo() {
    _currentLoaded = _currentLoaded.copyWith(
      promoCode: null,
      discountRate: 0.0,
    );
    emit(_currentLoaded);
  }

  void placeOrder() {
    if (_currentLoaded.cartItems.isEmpty) return;

    final orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final newOrder = OrderRecord(
      orderId: orderId,
      orderDate: DateTime.now(),
      items: List.from(_currentLoaded.cartItems),
      totalAmount: _currentLoaded.total,
      isDelivery: _currentLoaded.isDelivery,
      address: _currentLoaded.deliveryAddress,
    );

    final newStamps =
        (_currentLoaded.beanStamps + _currentLoaded.totalCartCount) % 10;

    _currentLoaded = _currentLoaded.copyWith(
      cartItems: const [],
      promoCode: null,
      discountRate: 0.0,
      beanStamps: newStamps,
      orderHistory: [newOrder, ..._currentLoaded.orderHistory],
      message: 'Order #$orderId placed successfully!',
    );

    emit(CoffeeOrderSuccess(
      order: newOrder,
      message: 'Order #$orderId placed successfully!',
      currentData: _currentLoaded,
    ));
  }

  void resetStatus() {
    emit(_currentLoaded);
  }
}
