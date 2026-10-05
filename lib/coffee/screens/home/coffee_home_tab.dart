import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../models/coffee_item.dart';
import '../../widgets/coffee_card.dart';
import '../../widgets/coffee_svg_icon.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class CoffeeHomeTab extends StatefulWidget {
  final VoidCallback? onOpenProfile;

  const CoffeeHomeTab({super.key, this.onOpenProfile});

  @override
  State<CoffeeHomeTab> createState() => _CoffeeHomeTabState();
}

class _CoffeeHomeTabState extends State<CoffeeHomeTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkRoast : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    AppStrings.filterCoffees,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF241913),
                  ),
                  AppButton.text(
                    onPressed: () {
                      context.read<HomeCubit>().resetFilter();
                      Navigator.pop(bottomSheetContext);
                    },
                    label: AppStrings.reset,
                    foregroundColor: AppTheme.primaryCoffee,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppText(
                AppStrings.roastPreference,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : const Color(0xFF5B4F45),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All Roasts',
                  'Dark Roast',
                  'Medium Roast',
                  'Arabica Blend',
                ].map((roast) {
                  return BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      final selectedRoast =
                          state is HomeSuccess ? state.selectedRoast : 'All Roasts';
                      final isSelected = selectedRoast == roast;
                      return ActionChip(
                        label: AppText(
                          roast,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? Colors.white
                                  : const Color(0xFF241913)),
                        ),
                        backgroundColor: isSelected
                            ? AppTheme.primaryCoffee
                            : (isDark
                                ? AppTheme.cardDark
                                : const Color(0xFFF3ECE6)),
                        onPressed: () {
                          context.read<HomeCubit>().setRoastFilter(roast);
                          Navigator.pop(bottomSheetContext);
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Dark Hero Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Dark Background Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 80),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF131313),
                        Color(0xFF2E241E),
                        Color(0xFF1C130E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location & Profile Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  CoffeeSvgIcon(
                                    assetName: AppImages.svgLocation,
                                    size: 14,
                                    color: Color(0xFFA59B93),
                                    fallbackIcon: Icons.location_on_outlined,
                                  ),
                                  SizedBox(width: 4),
                                  AppText(
                                    AppStrings.location,
                                    fontSize: 12,
                                    color: Color(0xFFA59B93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                children: [
                                  AppText(
                                    AppStrings.defaultLocation,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Avatar
                          GestureDetector(
                            onTap: widget.onOpenProfile,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryCoffee,
                                  width: 1.5,
                                ),
                              ),
                              child: const CustomCachedImage(
                                imageUrl: AppImages.pngAvatar,
                                borderRadius: BorderRadius.all(Radius.circular(22)),
                                fit: BoxFit.cover,
                                fallbackIcon: Icons.person,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search Bar Row (Driven by HomeCubit, ZERO setState)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF26211E),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, homeState) {
                                  final query = homeState is HomeSuccess
                                      ? homeState.searchQuery
                                      : '';
                                  return AppTextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      context.read<HomeCubit>().setSearchQuery(val);
                                    },
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    hintText: AppStrings.searchHint,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF988C83),
                                      fontSize: 14,
                                    ),
                                    prefixWidget: const Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child: CoffeeSvgIcon(
                                        assetName: AppImages.svgCoffeeCup,
                                        size: 18,
                                        color: Color(0xFFC67C4E),
                                        fallbackIcon: Icons.search_rounded,
                                      ),
                                    ),
                                    suffixIcon: query.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear,
                                                color: Colors.white70, size: 18),
                                            onPressed: () {
                                              _searchController.clear();
                                              context.read<HomeCubit>().clearSearch();
                                            },
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Filter Button
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showFilterModal(context),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryCoffee,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryCoffee
                                        .withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: CoffeeSvgIcon(
                                  assetName: AppImages.svgFilter,
                                  size: 20,
                                  color: Colors.white,
                                  fallbackIcon: Icons.tune_rounded,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Floating Promo Banner Card
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: -64,
                  child: Container(
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomCachedImage(
                              imageUrl: AppImages.imgHeroCoffee,
                              fit: BoxFit.cover,
                              fallbackIcon: Icons.coffee_rounded,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: const [0.0, 0.6, 1.0],
                                  colors: [
                                    Colors.black.withValues(alpha: 0.88),
                                    Colors.black.withValues(alpha: 0.65),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFED5151),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const AppText(
                                    AppStrings.promoBadge,
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const AppText(
                                  AppStrings.promoHeadline,
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // Horizontal Category Selector (HomeCubit)
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final selectedCategory =
                    state is HomeSuccess ? state.selectedCategory : 'All Coffee';

                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    itemCount: CoffeeRepository.categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = CoffeeRepository.categories[index];
                      final isSelected = selectedCategory == category;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          context.read<HomeCubit>().setCategory(category);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryCoffee
                                : (isDark
                                    ? AppTheme.cardDark
                                    : const Color(0xFFF3ECE6)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryCoffee
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFE5DDD5)),
                            ),
                          ),
                          child: Center(
                            child: AppText(
                              category,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? const Color(0xFFA59B93)
                                      : const Color(0xFF6E5F55)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // 2-Column Coffee Grid (HomeCubit & FavoritesCubit)
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, homeState) {
                  if (homeState is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryCoffee,
                      ),
                    );
                  }

                  if (homeState is HomeError) {
                    return Center(
                      child: AppText(
                        homeState.errorMessage,
                        color: Colors.redAccent,
                      ),
                    );
                  }

                  final coffees = homeState is HomeSuccess
                      ? homeState.filteredCoffees
                      : <CoffeeItem>[];

                  if (coffees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CoffeeSvgIcon(
                            assetName: AppImages.svgCoffeeCup,
                            size: 54,
                            color: AppTheme.primaryCoffee,
                          ),
                          const SizedBox(height: 14),
                          AppText(
                            AppStrings.noCoffeeFound,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF241913),
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            AppStrings.noCoffeeFoundSubtitle,
                            fontSize: 13,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF86766B),
                          ),
                        ],
                      ),
                    );
                  }

                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favState) {
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(22, 6, 22, 24),
                        itemCount: coffees.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final coffee = coffees[index];
                          final isFav = favState is FavoritesSuccess &&
                              favState.isFav(coffee.id);
                          return CoffeeCard(
                            coffee: coffee,
                            isFavorite: isFav,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
