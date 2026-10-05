import '../../../../core/constants/strings.dart';
import '../../../models/cart_item.dart';

abstract class CartState {
  const CartState();

  int get totalCartCount => this is CartSuccess ? (this as CartSuccess).totalCartCount : 0;
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  final List<CartItem> cartItems;
  final bool isDelivery;
  final String deliveryAddress;
  final String? promoCode;
  final double discountRate;

  const CartSuccess({
    this.cartItems = const [],
    this.isDelivery = true,
    this.deliveryAddress = AppStrings.defaultDeliveryAddress,
    this.promoCode,
    this.discountRate = 0.0,
  });

  @override
  int get totalCartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => isDelivery ? (subtotal > 20.0 ? 0.0 : 1.50) : 0.0;

  double get discountAmount => subtotal * discountRate;

  double get total =>
      (subtotal + deliveryFee - discountAmount).clamp(0.0, 9999.0);

  CartSuccess copyWith({
    List<CartItem>? cartItems,
    bool? isDelivery,
    String? deliveryAddress,
    String? promoCode,
    double? discountRate,
  }) {
    return CartSuccess(
      cartItems: cartItems ?? this.cartItems,
      isDelivery: isDelivery ?? this.isDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      promoCode: promoCode ?? this.promoCode,
      discountRate: discountRate ?? this.discountRate,
    );
  }
}

// Backward-compatibility alias
typedef CartLoaded = CartSuccess;

class CartOrderSuccessState extends CartState {
  final String message;

  const CartOrderSuccessState({
    this.message = 'Order placed successfully!',
  });
}

class CartError extends CartState {
  final String errorMessage;

  const CartError(this.errorMessage);
}
