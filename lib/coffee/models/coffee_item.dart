import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/images.dart';

class CoffeeItem extends Equatable {
  final String id;
  final String name;
  final String category;
  final String subtitle;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String image;
  final String roastLevel;
  final bool isPopular;
  final List<String> sizes;
  final Map<String, double> sizePriceOffsets;
  final int stock;
  final int calories;
  final DateTime? createdAt;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.roastLevel,
    this.isPopular = false,
    this.sizes = const ['S', 'M', 'L'],
    this.sizePriceOffsets = const {'S': -0.40, 'M': 0.0, 'L': 0.60},
    this.stock = 50,
    this.calories = 180,
    this.createdAt,
  });

  double priceForSize(String size) {
    final offset = sizePriceOffsets[size] ?? 0.0;
    return (price + offset).clamp(0.5, 999.0);
  }

  CoffeeItem copyWith({
    String? id,
    String? name,
    String? category,
    String? subtitle,
    String? description,
    double? price,
    double? rating,
    int? reviewCount,
    String? image,
    String? roastLevel,
    bool? isPopular,
    List<String>? sizes,
    Map<String, double>? sizePriceOffsets,
    int? stock,
    int? calories,
    DateTime? createdAt,
  }) {
    return CoffeeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      image: image ?? this.image,
      roastLevel: roastLevel ?? this.roastLevel,
      isPopular: isPopular ?? this.isPopular,
      sizes: sizes ?? this.sizes,
      sizePriceOffsets: sizePriceOffsets ?? this.sizePriceOffsets,
      stock: stock ?? this.stock,
      calories: calories ?? this.calories,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'image': image,
      'roastLevel': roastLevel,
      'isPopular': isPopular,
      'sizes': sizes,
      'sizePriceOffsets': sizePriceOffsets,
      'stock': stock,
      'calories': calories,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory CoffeeItem.fromMap(Map<String, dynamic> map, String id) {
    double parsedPrice = 0.0;
    if (map['price'] is num) {
      parsedPrice = (map['price'] as num).toDouble();
    } else if (map['price'] is String) {
      parsedPrice = double.tryParse(map['price']) ?? 0.0;
    }

    double parsedRating = 4.5;
    if (map['rating'] is num) {
      parsedRating = (map['rating'] as num).toDouble();
    } else if (map['rating'] is String) {
      parsedRating = double.tryParse(map['rating']) ?? 4.5;
    }

    int parsedReviewCount = 0;
    if (map['reviewCount'] is num) {
      parsedReviewCount = (map['reviewCount'] as num).toInt();
    } else if (map['reviewCount'] is String) {
      parsedReviewCount = int.tryParse(map['reviewCount']) ?? 0;
    }

    int parsedStock = 50;
    if (map['stock'] is num) {
      parsedStock = (map['stock'] as num).toInt();
    } else if (map['stock'] is String) {
      parsedStock = int.tryParse(map['stock']) ?? 50;
    }

    int parsedCalories = 180;
    if (map['calories'] is num) {
      parsedCalories = (map['calories'] as num).toInt();
    } else if (map['calories'] is String) {
      parsedCalories = int.tryParse(map['calories']) ?? 180;
    }

    List<String> parsedSizes = const ['S', 'M', 'L'];
    if (map['sizes'] is List) {
      parsedSizes = (map['sizes'] as List).map((e) => e.toString()).toList();
    }

    Map<String, double> parsedOffsets = const {'S': -0.40, 'M': 0.0, 'L': 0.60};
    if (map['sizePriceOffsets'] is Map) {
      parsedOffsets = {};
      (map['sizePriceOffsets'] as Map).forEach((k, v) {
        if (v is num) {
          parsedOffsets[k.toString()] = v.toDouble();
        } else if (v is String) {
          parsedOffsets[k.toString()] = double.tryParse(v) ?? 0.0;
        }
      });
    }

    DateTime? parsedCreatedAt;
    if (map['createdAt'] is Timestamp) {
      parsedCreatedAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(map['createdAt']);
    }

    return CoffeeItem(
      id: id,
      name: map['name']?.toString() ?? 'Specialty Coffee',
      category: map['category']?.toString() ?? 'All Coffee',
      subtitle: map['subtitle']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: parsedPrice,
      rating: parsedRating,
      reviewCount: parsedReviewCount,
      image: map['image']?.toString() ?? AppImages.imgCappuccino,
      roastLevel: map['roastLevel']?.toString() ?? 'Medium Roast',
      isPopular: map['isPopular'] == true,
      sizes: parsedSizes,
      sizePriceOffsets: parsedOffsets,
      stock: parsedStock,
      calories: parsedCalories,
      createdAt: parsedCreatedAt,
    );
  }

  factory CoffeeItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CoffeeItem.fromMap(data, doc.id);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        subtitle,
        description,
        price,
        rating,
        reviewCount,
        image,
        roastLevel,
        isPopular,
        sizes,
        sizePriceOffsets,
        stock,
        calories,
        createdAt,
      ];
}

class CoffeeRepository {
  static const List<String> categories = [
    'All Coffee',
    'Machiato',
    'Latte',
    'Cappuccino',
    'Espresso',
    'Cold Brew',
    'Bakery',
  ];

  static const List<CoffeeItem> sampleCoffees = [
    CoffeeItem(
      id: 'caramel_macchiato',
      name: 'Caramel Macchiato',
      category: 'Machiato',
      subtitle: 'With Salted Drizzle',
      description:
          'Freshly steamed milk with vanilla-flavored syrup marked with espresso and topped with a decadent caramel drizzle for a sweet finish.',
      price: 4.53,
      rating: 4.9,
      reviewCount: 420,
      image: AppImages.imgCaramelMacchiato,
      roastLevel: 'Arabica Blend',
      isPopular: true,
      stock: 50,
      calories: 210,
    ),
    CoffeeItem(
      id: 'classic_cappuccino',
      name: 'Classic Cappuccino',
      category: 'Cappuccino',
      subtitle: 'Velvety Thick Foam',
      description:
          'Dark, rich espresso lies in wait under a smoothed and stretched layer of thick milk foam. An artisanal classic crafted by our master baristas.',
      price: 4.20,
      rating: 4.8,
      reviewCount: 382,
      image: AppImages.imgCappuccino,
      roastLevel: 'Dark Roast',
      isPopular: true,
      stock: 45,
      calories: 140,
    ),
    CoffeeItem(
      id: 'caffe_latte',
      name: 'Caffe Latte',
      category: 'Latte',
      subtitle: 'Delicate Micro-foam',
      description:
          'Our dark, rich espresso balanced with steamed milk and a light layer of foam. A perfect, soothing morning companion with smooth notes.',
      price: 4.10,
      rating: 4.7,
      reviewCount: 295,
      image: AppImages.imgLatte,
      roastLevel: 'Medium Roast',
      isPopular: true,
      stock: 60,
      calories: 190,
    ),
    CoffeeItem(
      id: 'double_espresso',
      name: 'Double Espresso',
      category: 'Espresso',
      subtitle: 'Pure Italian Crema',
      description:
          'Two full shots of our signature deep roast espresso. Intense, aromatic, and crowned with a thick golden-hazel crema.',
      price: 3.50,
      rating: 4.9,
      reviewCount: 198,
      image: AppImages.imgEspresso,
      roastLevel: 'Single Origin',
      isPopular: false,
      sizes: ['S', 'M'],
      sizePriceOffsets: {'S': -0.30, 'M': 0.0},
      stock: 80,
      calories: 10,
    ),
    CoffeeItem(
      id: 'choco_mocha',
      name: 'Choco Mocha',
      category: 'Latte',
      subtitle: 'Bittersweet Cocoa',
      description:
          'Espresso with chocolate sauce, creamy steamed milk, and whipped chocolate froth on top. Rich, velvety, and deeply satisfying.',
      price: 4.80,
      rating: 4.8,
      reviewCount: 512,
      image: AppImages.imgMocha,
      roastLevel: 'Dark Cocoa Blend',
      isPopular: true,
      stock: 35,
      calories: 320,
    ),
    CoffeeItem(
      id: 'flat_white',
      name: 'Flat White',
      category: 'Cappuccino',
      subtitle: 'Silky Velvety Milk',
      description:
          'Smooth ristretto shots of espresso paired with the ideal amount of steamed whole milk for an expertly crafted, bold beverage.',
      price: 4.40,
      rating: 4.8,
      reviewCount: 230,
      image: AppImages.imgFlatWhite,
      roastLevel: 'Medium Roast',
      isPopular: false,
      stock: 40,
      calories: 160,
    ),
    CoffeeItem(
      id: 'cold_brew',
      name: 'Cold Brew Reserve',
      category: 'Cold Brew',
      subtitle: '20hr Slow Steeped',
      description:
          'Handcrafted in small batches daily, slow-steeped in cool filtered water for 20 hours, with a smooth, naturally sweet profile.',
      price: 4.75,
      rating: 4.9,
      reviewCount: 340,
      image: AppImages.imgColdBrew,
      roastLevel: 'Cold Extraction',
      isPopular: true,
      sizes: ['M', 'L'],
      sizePriceOffsets: {'M': 0.0, 'L': 0.60},
      stock: 55,
      calories: 15,
    ),
    CoffeeItem(
      id: 'french_croissant',
      name: 'Butter Croissant',
      category: 'Bakery',
      subtitle: 'Bakery Special',
      description:
          'Classic French pastry made with 100% pure Normandy butter, baked fresh every morning until flaky, golden, and heavenly.',
      price: 3.25,
      rating: 4.7,
      reviewCount: 165,
      image: AppImages.imgCroissant,
      roastLevel: 'Artisan Bakery',
      isPopular: false,
      sizes: ['Single', 'Pair (+1.80)'],
      sizePriceOffsets: {'Single': 0.0, 'Pair (+1.80)': 1.80},
      stock: 25,
      calories: 260,
    ),
  ];
}
