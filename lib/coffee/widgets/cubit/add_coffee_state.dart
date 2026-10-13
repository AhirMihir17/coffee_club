import 'package:equatable/equatable.dart';

class AddCoffeeState extends Equatable {
  final String name;
  final String subtitle;
  final String category;
  final String description;
  final String priceText;
  final String ratingText;
  final String reviewCountText;
  final String caloriesText;
  final String stockText;
  final String roastLevel;
  final bool isPopular;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AddCoffeeState({
    this.name = '',
    this.subtitle = '',
    this.category = 'Latte',
    this.description = '',
    this.priceText = '4.50',
    this.ratingText = '4.8',
    this.reviewCountText = '120',
    this.caloriesText = '180',
    this.stockText = '50',
    this.roastLevel = 'Medium Roast',
    this.isPopular = true,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AddCoffeeState copyWith({
    String? name,
    String? subtitle,
    String? category,
    String? description,
    String? priceText,
    String? ratingText,
    String? reviewCountText,
    String? caloriesText,
    String? stockText,
    String? roastLevel,
    bool? isPopular,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AddCoffeeState(
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      description: description ?? this.description,
      priceText: priceText ?? this.priceText,
      ratingText: ratingText ?? this.ratingText,
      reviewCountText: reviewCountText ?? this.reviewCountText,
      caloriesText: caloriesText ?? this.caloriesText,
      stockText: stockText ?? this.stockText,
      roastLevel: roastLevel ?? this.roastLevel,
      isPopular: isPopular ?? this.isPopular,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        name,
        subtitle,
        category,
        description,
        priceText,
        ratingText,
        reviewCountText,
        caloriesText,
        stockText,
        roastLevel,
        isPopular,
        isLoading,
        errorMessage,
        isSuccess,
      ];
}
