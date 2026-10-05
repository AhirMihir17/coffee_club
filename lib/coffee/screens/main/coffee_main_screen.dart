import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/model/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../cart/coffee_cart_tab.dart';
import '../cart/cubit/cart_cubit.dart';
import '../cart/cubit/cart_state.dart';
import '../favorites/coffee_favorites_tab.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../home/coffee_home_tab.dart';
import '../home/cubit/home_cubit.dart';
import '../profile/coffee_profile_tab.dart';
import '../profile/cubit/profile_cubit.dart';
import 'cubit/navigation_cubit.dart';
import 'cubit/navigation_state.dart';

class CoffeeMainScreen extends StatelessWidget {
  final AppUser? user;

  const CoffeeMainScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return _CoffeeMainProviders(
      user: user,
      child: _CoffeeMainScreenBody(user: user),
    );
  }
}

class _CoffeeMainProviders extends StatelessWidget {
  final AppUser? user;
  final Widget child;

  const _CoffeeMainProviders({this.user, required this.child});

  @override
  Widget build(BuildContext context) {
    final existingNav = _safeRead<NavigationCubit>(context);
    final existingHome = _safeRead<HomeCubit>(context);
    final existingCart = _safeRead<CartCubit>(context);
    final existingFav = _safeRead<FavoritesCubit>(context);
    final existingProfile = _safeRead<ProfileCubit>(context);

    Widget current = child;

    current = existingProfile != null
        ? BlocProvider<ProfileCubit>.value(value: existingProfile, child: current)
        : BlocProvider<ProfileCubit>(
            create: (_) => ProfileCubit(user: user),
            child: current,
          );

    current = existingFav != null
        ? BlocProvider<FavoritesCubit>.value(value: existingFav, child: current)
        : BlocProvider<FavoritesCubit>(
            create: (_) => FavoritesCubit(),
            child: current,
          );

    current = existingCart != null
        ? BlocProvider<CartCubit>.value(value: existingCart, child: current)
        : BlocProvider<CartCubit>(
            create: (_) => CartCubit(),
            child: current,
          );

    current = existingHome != null
        ? BlocProvider<HomeCubit>.value(value: existingHome, child: current)
        : BlocProvider<HomeCubit>(
            create: (_) => HomeCubit(),
            child: current,
          );

    current = existingNav != null
        ? BlocProvider<NavigationCubit>.value(value: existingNav, child: current)
        : BlocProvider<NavigationCubit>(
            create: (_) => NavigationCubit(),
            child: current,
          );

    return current;
  }

  static T? _safeRead<T extends StateStreamableSource<Object?>>(
      BuildContext context) {
    try {
      return BlocProvider.of<T>(context, listen: false);
    } catch (_) {
      return null;
    }
  }
}

class _CoffeeMainScreenBody extends StatelessWidget {
  final AppUser? user;

  const _CoffeeMainScreenBody({this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navState) {
        final currentIndex = navState.selectedIndex;
        final navCubit = context.read<NavigationCubit>();

        final tabs = [
          CoffeeHomeTab(
            onOpenProfile: () => navCubit.setTab(3),
          ),
          CoffeeFavoritesTab(
            onExploreMenu: () => navCubit.setTab(0),
          ),
          CoffeeCartTab(
            onExploreMenu: () => navCubit.setTab(0),
          ),
          CoffeeProfileTab(
            user: user,
          ),
        ];

        return Scaffold(
          backgroundColor:
              isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
          body: IndexedStack(
            index: currentIndex,
            children: tabs,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF191512) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFEDE5DF),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      index: 0,
                      currentIndex: currentIndex,
                      icon: Icons.home_rounded,
                      activeIcon: Icons.home_filled,
                      onTap: () => navCubit.setTab(0),
                    ),
                    _NavBarItem(
                      index: 1,
                      currentIndex: currentIndex,
                      icon: Icons.favorite_border_rounded,
                      activeIcon: Icons.favorite_rounded,
                      onTap: () => navCubit.setTab(1),
                    ),
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, cartState) {
                        return _NavBarItem(
                          index: 2,
                          currentIndex: currentIndex,
                          icon: Icons.shopping_bag_outlined,
                          activeIcon: Icons.shopping_bag_rounded,
                          badgeCount: cartState.totalCartCount,
                          onTap: () => navCubit.setTab(2),
                        );
                      },
                    ),
                    _NavBarItem(
                      index: 3,
                      currentIndex: currentIndex,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      onTap: () => navCubit.setTab(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 26,
                  color: isSelected
                      ? AppTheme.primaryCoffee
                      : const Color(0xFF988C83),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFED5151),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: AppText(
                        '$badgeCount',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 12 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryCoffee : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
