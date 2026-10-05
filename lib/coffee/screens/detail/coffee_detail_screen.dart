import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../models/coffee_item.dart';
import '../../widgets/coffee_svg_icon.dart';
import '../cart/cubit/cart_cubit.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';
import 'cubit/coffee_detail_cubit.dart';
import 'cubit/coffee_detail_state.dart';

class CoffeeDetailScreen extends StatelessWidget {
  final CoffeeItem coffee;

  const CoffeeDetailScreen({super.key, required this.coffee});

  static const List<String> _milkOptions = [
    'Whole Milk',
    'Oat Milk',
    'Almond Milk',
    'Soy Milk',
    'Non-Fat',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoffeeDetailCubit>(
      create: (_) => CoffeeDetailCubit(),
      child: _CoffeeDetailView(coffee: coffee, milkOptions: _milkOptions),
    );
  }
}

class _CoffeeDetailView extends StatelessWidget {
  final CoffeeItem coffee;
  final List<String> milkOptions;

  const _CoffeeDetailView({
    required this.coffee,
    required this.milkOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CoffeeDetailCubit, CoffeeDetailState>(
      builder: (context, detailState) {
        final detailCubit = context.read<CoffeeDetailCubit>();
        final unitPrice = coffee.priceForSize(detailState.selectedSize);
        final totalPrice = unitPrice * detailState.quantity;

        return Scaffold(
          backgroundColor:
              isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
          body: SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RoundIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      AppText(
                        AppStrings.detailTitle,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? Colors.white : const Color(0xFF241913),
                      ),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favState) {
                          final isFav = favState is FavoritesSuccess &&
                              favState.isFav(coffee.id);
                          return _RoundIconButton(
                            onTap: () {
                              context
                                  .read<FavoritesCubit>()
                                  .toggleFavorite(coffee.id);
                            },
                            child: CoffeeSvgIcon(
                              assetName: isFav
                                  ? AppImages.svgHeartFilled
                                  : AppImages.svgHeart,
                              size: 20,
                              color: isFav ? AppTheme.accentHeart : null,
                              fallbackIcon: isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Image
                        Hero(
                          tag: 'coffee_${coffee.id}',
                          child: Container(
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: CustomCachedImage(
                              imageUrl: coffee.image,
                              borderRadius: BorderRadius.circular(24),
                              fit: BoxFit.cover,
                              height: 240,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Coffee Name and Roast Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    coffee.name,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF241913),
                                    letterSpacing: -0.3,
                                  ),
                                  const SizedBox(height: 4),
                                  AppText(
                                    coffee.subtitle,
                                    fontSize: 14,
                                    color: isDark
                                        ? const Color(0xFFA59B93)
                                        : const Color(0xFF86766B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            // Badges Row
                            Row(
                              children: [
                                const _IconBadge(
                                  assetName: AppImages.svgDelivery,
                                  tooltip: AppStrings.fastDelivery,
                                  fallbackIcon: Icons.delivery_dining_rounded,
                                ),
                                const SizedBox(width: 10),
                                _IconBadge(
                                  assetName: AppImages.svgCoffeeBean,
                                  tooltip: coffee.roastLevel,
                                  fallbackIcon: Icons.eco_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Rating and Reviews Row
                        Row(
                          children: [
                            const CoffeeSvgIcon(
                              assetName: AppImages.svgStar,
                              size: 18,
                              color: AppTheme.goldenStar,
                              fallbackIcon: Icons.star_rounded,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              coffee.rating.toStringAsFixed(1),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF241913),
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              '(${coffee.reviewCount})',
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF8D827A)
                                  : const Color(0xFF9E9289),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryCoffee
                                  .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AppText(
                                coffee.roastLevel,
                                fontSize: 12,
                                color: AppTheme.primaryCoffee,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Divider(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : const Color(0xFFE5DDD5),
                        ),
                        const SizedBox(height: 12),

                        // Description (toggled via CoffeeDetailCubit)
                        AppText(
                          AppStrings.descriptionTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF241913),
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          coffee.description,
                          maxLines:
                              detailState.isDescriptionExpanded ? 100 : 3,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 13.5,
                          height: 1.5,
                          color: isDark
                              ? const Color(0xFFA59B93)
                              : const Color(0xFF7E726A),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: detailCubit.toggleDescription,
                          child: AppText(
                            detailState.isDescriptionExpanded
                                ? AppStrings.readLess
                                : AppStrings.readMore,
                            color: AppTheme.primaryCoffee,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Size Selection (CoffeeDetailCubit)
                        AppText(
                          AppStrings.sizeTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF241913),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: coffee.sizes.map((size) {
                            final isSelected =
                                detailState.selectedSize == size;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => detailCubit.setSize(size),
                                  child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (isDark
                                              ? AppTheme.primaryCoffee
                                                  .withValues(alpha: 0.25)
                                              : const Color(0xFFF9F0E8))
                                          : (isDark
                                              ? AppTheme.cardDark
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryCoffee
                                            : (isDark
                                                ? Colors.white
                                                    .withValues(alpha: 0.1)
                                                : const Color(0xFFE5DDD5)),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: AppText(
                                        size,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.primaryCoffee
                                            : (isDark
                                                ? Colors.white
                                                : const Color(0xFF241913)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Milk Option (CoffeeDetailCubit)
                        AppText(
                          AppStrings.milkTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF241913),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: milkOptions.map((milk) {
                            final isSelected =
                                detailState.selectedMilk == milk;
                            return ChoiceChip(
                              label: AppText(
                                milk,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white
                                        : const Color(0xFF241913)),
                              ),
                              selected: isSelected,
                              onSelected: (_) => detailCubit.setMilk(milk),
                              selectedColor: AppTheme.primaryCoffee,
                              backgroundColor: isDark
                                  ? AppTheme.cardDark
                                  : const Color(0xFFF3ECE6),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Temperature Control
                        AppText(
                          AppStrings.temperatureTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              isDark ? Colors.white : const Color(0xFF241913),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _ChoicePill(
                              icon: Icons.local_fire_department_rounded,
                              label: AppStrings.hot,
                              isSelected: detailState.selectedIce == 'Hot',
                              onTap: () => detailCubit.setIce('Hot'),
                            ),
                            const SizedBox(width: 12),
                            _ChoicePill(
                              icon: Icons.ac_unit_rounded,
                              label: AppStrings.iced,
                              isSelected: detailState.selectedIce == 'Iced',
                              onTap: () => detailCubit.setIce('Iced'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Sweetness Control
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              AppStrings.sweetnessTitle,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF241913),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.primaryCoffee
                                        .withValues(alpha: 0.18)
                                    : const Color(0xFFF9F0E8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryCoffee
                                      .withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: AppText(
                                detailState.selectedSweetness,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryCoffee,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _ChoicePill(
                              icon: Icons.water_drop_rounded,
                              label: AppStrings.regular,
                              subtitle: '100% Sweet',
                              isSelected: detailState.selectedSweetness ==
                                  'Regular',
                              onTap: () =>
                                  detailCubit.setSweetness('Regular'),
                            ),
                            const SizedBox(width: 10),
                            _ChoicePill(
                              icon: Icons.opacity_rounded,
                              label: AppStrings.lessSweet,
                              subtitle: '50% Sweet',
                              isSelected: detailState.selectedSweetness ==
                                  'Less Sweet',
                              onTap: () =>
                                  detailCubit.setSweetness('Less Sweet'),
                            ),
                            const SizedBox(width: 10),
                            _ChoicePill(
                              icon: Icons.block_rounded,
                              label: AppStrings.noSugar,
                              subtitle: '0% Sweet',
                              isSelected: detailState.selectedSweetness ==
                                  'No Sugar',
                              onTap: () =>
                                  detailCubit.setSweetness('No Sugar'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Quantity Counter (CoffeeDetailCubit)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              AppStrings.quantityTitle,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF241913),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.cardDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : const Color(0xFFE5DDD5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _StepButton(
                                    icon: Icons.remove,
                                    onTap: detailState.quantity > 1
                                        ? detailCubit.decrementQuantity
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: AppText(
                                      '${detailState.quantity}',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF241913),
                                    ),
                                  ),
                                  _StepButton(
                                    icon: Icons.add,
                                    onTap: detailCubit.incrementQuantity,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Bottom Checkout Bar (CartCubit)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkRoast : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            AppStrings.price,
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFA59B93)
                                : const Color(0xFF86766B),
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            '\$ ${totalPrice.toStringAsFixed(2)}',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryCoffee,
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Add to Cart Button (Calls CartCubit directly!)
                      Expanded(
                        child: AppButton.primary(
                          label: AppStrings.addToCart,
                          height: 52,
                          borderRadius: BorderRadius.circular(18),
                          onPressed: () {
                            context.read<CartCubit>().addToCart(
                                  coffee,
                                  size: detailState.selectedSize,
                                  milk: detailState.selectedMilk,
                                  quantity: detailState.quantity,
                                  ice: detailState.selectedIce,
                                  sweetness: detailState.selectedSweetness,
                                );
                            AppToast.showSuccess(
                              context: context,
                              message:
                                  'Added ${detailState.quantity}x ${coffee.name} to cart',
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;

  const _RoundIconButton({this.icon, this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFEDE5DF),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(
            child: child ??
                Icon(
                  icon,
                  size: 18,
                  color: isDark ? Colors.white : const Color(0xFF241913),
                ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final String assetName;
  final String tooltip;
  final IconData fallbackIcon;

  const _IconBadge({
    required this.assetName,
    required this.tooltip,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : const Color(0xFFF3ECE6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5DDD5),
        ),
      ),
      child: Center(
        child: CoffeeSvgIcon(
          assetName: assetName,
          size: 20,
          color: AppTheme.primaryCoffee,
          fallbackIcon: fallbackIcon,
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? AppTheme.primaryCoffee.withValues(alpha: 0.22)
                    : const Color(0xFFF9F0E8))
                : (isDark ? AppTheme.cardDark : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryCoffee
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFE5DDD5)),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? AppTheme.primaryCoffee
                      : (isDark ? Colors.white70 : const Color(0xFF6E5F55)),
                ),
                const SizedBox(height: 6),
              ],
              AppText(
                label,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                textAlign: TextAlign.center,
                color: isSelected
                    ? AppTheme.primaryCoffee
                    : (isDark ? Colors.white : const Color(0xFF241913)),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                AppText(
                  subtitle!,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  color: isSelected
                      ? AppTheme.primaryCoffee.withValues(alpha: 0.85)
                      : (isDark ? Colors.white54 : const Color(0xFF9E9289)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFF2ECE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Icon(
            icon,
            size: 16,
            color: onTap == null
                ? Colors.grey
                : (isDark ? Colors.white : const Color(0xFF241913)),
          ),
        ),
      ),
    );
  }
}
