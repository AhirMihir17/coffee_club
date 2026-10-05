import '../models/cart_item.dart';
import '../models/coffee_item.dart';

class OrderRecord {
  final String orderId;
  final DateTime orderDate;
  final List<CartItem> items;
  final double totalAmount;
  final bool isDelivery;
  final String address;

  const OrderRecord({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.isDelivery,
    required this.address,
  });
}

abstract class CoffeeState {
  const CoffeeState();

  CoffeeLoaded? get data {
    if (this is CoffeeLoaded) return this as CoffeeLoaded;
    if (this is CoffeeOrderSuccess) {
      return (this as CoffeeOrderSuccess).currentData;
    }
    return null;
  }
}

class CoffeeInitial extends CoffeeState {
  const CoffeeInitial();
}

class CoffeeLoading extends CoffeeState {
  const CoffeeLoading();
}

class CoffeeLoaded extends CoffeeState {
  final List<CoffeeItem> allCoffees;
  final String selectedCategory;
  final String searchQuery;
  final List<CartItem> cartItems;
  final Set<String> favoriteIds;
  final bool isDelivery;
  final String deliveryAddress;
  final String? promoCode;
  final double discountRate;
  final int beanStamps;
  final List<OrderRecord> orderHistory;
  final String? message;

  const CoffeeLoaded({
    this.allCoffees = CoffeeRepository.sampleCoffees,
    this.selectedCategory = 'All Coffee',
    this.searchQuery = '',
    this.cartItems = const [],
    this.favoriteIds = const {'caramel_macchiato', 'classic_cappuccino'},
    this.isDelivery = true,
    this.deliveryAddress = 'Jl. Kpg Sutoyo No. 620, Bilzen, Tanjungbalai',
    this.promoCode,
    this.discountRate = 0.0,
    this.beanStamps = 8,
    this.orderHistory = const [],
    this.message,
  });

  List<CoffeeItem> get filteredCoffees {
    return allCoffees.where((coffee) {
      final matchesCategory = selectedCategory == 'All Coffee' ||
          coffee.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          coffee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          coffee.subtitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
          coffee.category.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<CoffeeItem> get favoriteCoffees {
    return allCoffees.where((c) => favoriteIds.contains(c.id)).toList();
  }

  int get totalCartCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (cartItems.isEmpty || !isDelivery) return 0.0;
    return subtotal > 20.0 ? 0.0 : 1.50;
  }

  double get discountAmount {
    return subtotal * discountRate;
  }

  double get total {
    if (cartItems.isEmpty) return 0.0;
    return (subtotal + deliveryFee - discountAmount).clamp(0.0, 9999.0);
  }

  CoffeeLoaded copyWith({
    List<CoffeeItem>? allCoffees,
    String? selectedCategory,
    String? searchQuery,
    List<CartItem>? cartItems,
    Set<String>? favoriteIds,
    bool? isDelivery,
    String? deliveryAddress,
    String? promoCode,
    double? discountRate,
    int? beanStamps,
    List<OrderRecord>? orderHistory,
    String? message,
  }) {
    return CoffeeLoaded(
      allCoffees: allCoffees ?? this.allCoffees,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      cartItems: cartItems ?? this.cartItems,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isDelivery: isDelivery ?? this.isDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      promoCode: promoCode ?? this.promoCode,
      discountRate: discountRate ?? this.discountRate,
      beanStamps: beanStamps ?? this.beanStamps,
      orderHistory: orderHistory ?? this.orderHistory,
      message: message,
    );
  }

}

class CoffeeOrderSuccess extends CoffeeState {
  final OrderRecord order;
  final String message;
  final CoffeeLoaded currentData;

  const CoffeeOrderSuccess({
    required this.order,
    required this.message,
    required this.currentData,
  });
}

class CoffeeError extends CoffeeState {
  final String errorMessage;

  const CoffeeError(this.errorMessage);

  String get message => errorMessage;
}
