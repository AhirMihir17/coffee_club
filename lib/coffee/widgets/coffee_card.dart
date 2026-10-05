import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../cubit/coffee_cubit.dart';
import '../screens/cart/cubit/cart_cubit.dart';
import '../screens/favorites/cubit/favorites_cubit.dart';
import '../models/coffee_item.dart';
import '../screens/detail/coffee_detail_screen.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/app_widgets.dart';
import 'coffee_svg_icon.dart';

class CoffeeCard extends StatelessWidget {
  final CoffeeItem coffee;
  final bool isFavorite;

  const CoffeeCard({
    super.key,
    required this.coffee,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFEDE5DF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFF4A2C1D).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CoffeeDetailScreen(coffee: coffee),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Rating & Favorite
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomCachedImage(
                          imageUrl: coffee.image,
                          borderRadius: BorderRadius.circular(16),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Rating Pill
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CoffeeSvgIcon(
                                assetName: AppImages.svgStar,
                                size: 12,
                                color: AppTheme.goldenStar,
                                fallbackIcon: Icons.star_rounded,
                              ),
                              const SizedBox(width: 4),
                              AppText(
                                coffee.rating.toStringAsFixed(1),
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Favorite Toggle
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              try {
                                context
                                    .read<FavoritesCubit>()
                                    .toggleFavorite(coffee.id);
                              } catch (_) {
                                context
                                    .read<CoffeeCubit>()
                                    .toggleFavorite(coffee.id);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                              child: CoffeeSvgIcon(
                                assetName: isFavorite ? AppImages.svgHeartFilled : AppImages.svgHeart,
                                size: 14,
                                color: isFavorite
                                    ? AppTheme.accentHeart
                                    : Colors.white,
                                fallbackIcon: isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Title
                AppText(
                  coffee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF241913),
                  letterSpacing: -0.2,
                ),
                const SizedBox(height: 3),
                // Subtitle
                AppText(
                  coffee.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF9E9289)
                      : const Color(0xFF86766B),
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 10),
                // Price & Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '\$ ',
                            style: TextStyle(
                              color: AppTheme.primaryCoffee,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: coffee.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF241913),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCoffee,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryCoffee.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(11),
                          onTap: () {
                            try {
                              context.read<CartCubit>().addToCart(
                                    coffee,
                                    size: 'M',
                                    milk: 'Whole Milk',
                                    quantity: 1,
                                  );
                            } catch (_) {
                              context.read<CoffeeCubit>().addToCart(
                                    coffee,
                                    size: 'M',
                                    milk: 'Whole Milk',
                                    quantity: 1,
                                  );
                            }
                            AppToast.showSuccess(
                              context: context,
                              message: 'Added ${coffee.name} to cart',
                            );
                          },
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
