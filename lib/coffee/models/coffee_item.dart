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
  });

  double priceForSize(String size) {
    final offset = sizePriceOffsets[size] ?? 0.0;
    return (price + offset).clamp(0.5, 999.0);
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
    ),
    CoffeeItem(
      id: 'french_croissant',
      name: 'Butter Croissant',
      category: 'All Coffee',
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
    ),
  ];
}
