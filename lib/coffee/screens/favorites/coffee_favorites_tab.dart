import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../widgets/coffee_card.dart';
import '../../widgets/coffee_svg_icon.dart';
import 'cubit/favorites_cubit.dart';
import 'cubit/favorites_state.dart';

class CoffeeFavoritesTab extends StatelessWidget {
  final VoidCallback? onExploreMenu;

  const CoffeeFavoritesTab({super.key, this.onExploreMenu});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    AppStrings.favoritesTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF241913),
                  ),
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final count = state is FavoritesSuccess
                          ? state.favoriteCoffees.length
                          : 0;
                      return AppText(
                        '$count items',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryCoffee,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryCoffee,
                      ),
                    );
                  }

                  if (state is FavoritesError) {
                    return Center(
                      child: AppText(
                        state.errorMessage,
                        color: Colors.redAccent,
                      ),
                    );
                  }

                  final favorites = state is FavoritesSuccess
                      ? state.favoriteCoffees
                      : [];

                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryCoffee
                                  .withValues(alpha: 0.12),
                            ),
                            child: const Center(
                              child: CoffeeSvgIcon(
                                assetName: AppImages.svgHeart,
                                size: 36,
                                color: AppTheme.primaryCoffee,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppText(
                            AppStrings.noFavoritesTitle,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF241913),
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            AppStrings.noFavoritesSubtitle,
                            fontSize: 13,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF86766B),
                          ),
                          const SizedBox(height: 20),
                          AppButton.primary(
                            label: AppStrings.discoverCoffees,
                            height: 46,
                            width: 200,
                            borderRadius: BorderRadius.circular(14),
                            onPressed: onExploreMenu,
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 24),
                    itemCount: favorites.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final coffee = favorites[index];
                      return CoffeeCard(
                        coffee: coffee,
                        isFavorite: true,
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
