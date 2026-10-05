import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../widgets/coffee_svg_icon.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CoffeeCartTab extends StatefulWidget {
  final VoidCallback? onExploreMenu;

  const CoffeeCartTab({super.key, this.onExploreMenu});

  @override
  State<CoffeeCartTab> createState() => _CoffeeCartTabState();
}

class _CoffeeCartTabState extends State<CoffeeCartTab> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _showOrderSuccessDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: isDark ? AppTheme.darkRoast : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCoffee.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CoffeeSvgIcon(
                      assetName: AppImages.svgCoffeeCup,
                      size: 42,
                      color: AppTheme.primaryCoffee,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppText(
                  AppStrings.orderPlaced,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF241913),
                ),
                const SizedBox(height: 8),
                AppText(
                  AppStrings.orderPlacedSubtitle,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  height: 1.4,
                  color: isDark
                      ? const Color(0xFFA59B93)
                      : const Color(0xFF7E726A),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardDark : const Color(0xFFF3ECE6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 18, color: AppTheme.primaryCoffee),
                      const SizedBox(width: 8),
                      AppText(
                        AppStrings.estimatedTime,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF241913),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton.primary(
                  label: AppStrings.backToMenu,
                  height: 48,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.read<CartCubit>().resetStatus();
                    widget.onExploreMenu?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditAddressModal(BuildContext context, String currentAddress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = TextEditingController(text: currentAddress);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.darkRoast : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(bottomSheetContext).viewInsets.bottom + 28,
          ),
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
              AppText(
                AppStrings.editAddress,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF241913),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: controller,
                autofocus: true,
                maxLines: 2,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF241913),
                  fontSize: 14,
                ),
                hintText: 'Enter street, house number, area...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : const Color(0xFFE5DDD5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: AppTheme.primaryCoffee, width: 1.5),
                ),
              ),
              const SizedBox(height: 18),
              AppButton.primary(
                label: 'Save Address',
                height: 48,
                borderRadius: BorderRadius.circular(16),
                onPressed: () {
                  final newAddr = controller.text.trim();
                  if (newAddr.isNotEmpty) {
                    context.read<CartCubit>().updateAddress(newAddr);
                  }
                  Navigator.of(bottomSheetContext).pop();
                },
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

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartOrderSuccessState) {
          _showOrderSuccessDialog(context);
        }
      },
      builder: (context, state) {
        if (state is CartLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryCoffee),
            ),
          );
        }

        if (state is CartError) {
          return Scaffold(
            body: Center(
              child: AppText(
                state.errorMessage,
                color: Colors.redAccent,
              ),
            ),
          );
        }

        final cartSuccess = state is CartSuccess ? state : const CartSuccess();
        final isDelivery = cartSuccess.isDelivery;
        final cartItems = cartSuccess.cartItems;

        return Scaffold(
          backgroundColor:
              isDark ? AppTheme.espressoBlack : AppTheme.creamWhite,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  child: Center(
                    child: AppText(
                      AppStrings.cartTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF241913),
                    ),
                  ),
                ),

                // Deliver vs Pick Up Toggle (CartCubit)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : const Color(0xFFF0E8E2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _DeliveryOptionTab(
                          title: AppStrings.deliver,
                          isSelected: isDelivery,
                          onTap: () =>
                              context.read<CartCubit>().setDelivery(true),
                        ),
                        _DeliveryOptionTab(
                          title: AppStrings.pickUp,
                          isSelected: !isDelivery,
                          onTap: () =>
                              context.read<CartCubit>().setDelivery(false),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Main Content or Empty State
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryCoffee
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: CoffeeSvgIcon(
                                    assetName: AppImages.svgCart,
                                    size: 42,
                                    color: AppTheme.primaryCoffee,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              AppText(
                                AppStrings.emptyCartTitle,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF241913),
                              ),
                              const SizedBox(height: 6),
                              AppText(
                                AppStrings.emptyCartSubtitle,
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF86766B),
                              ),
                              const SizedBox(height: 20),
                              AppButton.primary(
                                label: AppStrings.exploreMenu,
                                height: 46,
                                width: 170,
                                borderRadius: BorderRadius.circular(14),
                                onPressed: widget.onExploreMenu,
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Delivery Address Card
                              if (isDelivery) ...[
                                AppText(
                                  AppStrings.deliveryAddress,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF241913),
                                ),
                                const SizedBox(height: 8),
                                AppCard(
                                  padding: const EdgeInsets.all(16),
                                  borderRadius: 18,
                                  color: isDark
                                      ? AppTheme.cardDark
                                      : Colors.white,
                                  borderColor: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFEDE5DF),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        'Jl. Kpg Sutoyo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF241913),
                                      ),
                                      const SizedBox(height: 4),
                                      AppText(
                                        cartSuccess.deliveryAddress,
                                        fontSize: 12,
                                        color: isDark
                                            ? const Color(0xFFA59B93)
                                            : const Color(0xFF86766B),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          _AddressActionChip(
                                            icon: Icons.edit_outlined,
                                            label: AppStrings.editAddress,
                                            onTap: () => _showEditAddressModal(
                                                context, cartSuccess.deliveryAddress),
                                          ),
                                          const SizedBox(width: 8),
                                          _AddressActionChip(
                                            icon: Icons.note_add_outlined,
                                            label: AppStrings.addNote,
                                            onTap: () {
                                              AppToast.showSuccess(
                                                context: context,
                                                message:
                                                    'Note added: Ring doorbell',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                              ],

                              // Items List
                              AppText(
                                '${AppStrings.items} (${cartSuccess.totalCartCount})',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF241913),
                              ),
                              const SizedBox(height: 10),
                              ...cartItems.map((item) {
                                return AppCard(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  borderRadius: 18,
                                  color: isDark
                                      ? AppTheme.cardDark
                                      : Colors.white,
                                  borderColor: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFEDE5DF),
                                  child: Row(
                                    children: [
                                      // Image
                                      CustomCachedImage(
                                        imageUrl: item.coffee.image,
                                        width: 62,
                                        height: 62,
                                        borderRadius: BorderRadius.circular(14),
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 14),
                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              item.coffee.name,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF241913),
                                            ),
                                            const SizedBox(height: 3),
                                            AppText(
                                              'Size ${item.size}  •  ${item.milk}',
                                              fontSize: 11,
                                              color: isDark
                                                  ? const Color(0xFFA59B93)
                                                  : const Color(0xFF86766B),
                                            ),
                                            const SizedBox(height: 6),
                                            AppText(
                                              '\$ ${item.totalPrice.toStringAsFixed(2)}',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.primaryCoffee,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Stepper (CartCubit)
                                      Row(
                                        children: [
                                          _QtyButton(
                                            icon: Icons.remove,
                                            onTap: () => context
                                                .read<CartCubit>()
                                                .decrementQuantity(item.id),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: AppText(
                                              '${item.quantity}',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF241913),
                                            ),
                                          ),
                                          _QtyButton(
                                            icon: Icons.add,
                                            onTap: () => context
                                                .read<CartCubit>()
                                                .incrementQuantity(item.id),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const SizedBox(height: 10),

                              // Discount Coupon Card
                              AppCard(
                                padding: const EdgeInsets.all(14),
                                borderRadius: 16,
                                color: isDark
                                    ? AppTheme.cardDark
                                    : Colors.white,
                                borderColor: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : const Color(0xFFEDE5DF),
                                child: cartSuccess.promoCode != null
                                    ? Row(
                                        children: [
                                          const CoffeeSvgIcon(
                                            assetName: AppImages.svgPromoTag,
                                            size: 20,
                                            color: AppTheme.primaryCoffee,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  '${AppStrings.promoApplied}: ${cartSuccess.promoCode}',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(
                                                          0xFF241913),
                                                ),
                                                AppText(
                                                  '${(cartSuccess.discountRate * 100).toInt()}% discount on order',
                                                  fontSize: 11,
                                                  color: AppTheme.primaryCoffee,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                size: 18),
                                            onPressed: () => context
                                                .read<CartCubit>()
                                                .removePromo(),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          const CoffeeSvgIcon(
                                            assetName: AppImages.svgPromoTag,
                                            size: 20,
                                            color: AppTheme.primaryCoffee,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: AppTextField(
                                              controller: _promoController,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF241913),
                                              ),
                                              hintText:
                                                  AppStrings.enterPromoHint,
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                          AppButton.text(
                                            onPressed: () {
                                              final applied = context
                                                  .read<CartCubit>()
                                                  .applyPromo(
                                                      _promoController.text);
                                              if (applied) {
                                                _promoController.clear();
                                                AppToast.showSuccess(
                                                  context: context,
                                                  message:
                                                      '20% off coupon applied!',
                                                );
                                              } else {
                                                AppToast.showError(
                                                  context: context,
                                                  message:
                                                      'Invalid code. Try COFFEE20',
                                                );
                                              }
                                            },
                                            label: AppStrings.apply,
                                            foregroundColor: AppTheme.primaryCoffee,
                                          ),
                                        ],
                                      ),
                              ),

                              const SizedBox(height: 18),

                              // Payment Summary
                              AppText(
                                AppStrings.paymentSummary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF241913),
                              ),
                              const SizedBox(height: 10),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 18,
                                color: isDark
                                    ? AppTheme.cardDark
                                    : Colors.white,
                                borderColor: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : const Color(0xFFEDE5DF),
                                child: Column(
                                  children: [
                                    _SummaryRow(
                                      label: AppStrings.price,
                                      value:
                                          '\$ ${cartSuccess.subtotal.toStringAsFixed(2)}',
                                    ),
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      label: AppStrings.deliveryFee,
                                      value: isDelivery
                                          ? (cartSuccess.deliveryFee == 0
                                              ? AppStrings.free
                                              : '\$ ${cartSuccess.deliveryFee.toStringAsFixed(2)}')
                                          : 'FREE (Pick Up)',
                                      valueColor: cartSuccess.deliveryFee == 0
                                          ? Colors.green
                                          : null,
                                    ),
                                    if (cartSuccess.discountAmount > 0) ...[
                                      const SizedBox(height: 8),
                                      _SummaryRow(
                                        label: AppStrings.discount,
                                        value:
                                            '- \$ ${cartSuccess.discountAmount.toStringAsFixed(2)}',
                                        valueColor: AppTheme.primaryCoffee,
                                      ),
                                    ],
                                    Divider(
                                      height: 24,
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : const Color(0xFFEDE5DF),
                                    ),
                                    _SummaryRow(
                                      label: AppStrings.totalPayment,
                                      value:
                                          '\$ ${cartSuccess.total.toStringAsFixed(2)}',
                                      isBold: true,
                                      fontSize: 16,
                                      valueColor: AppTheme.primaryCoffee,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),

                // Bottom Checkout Button
                if (cartItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkRoast : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: AppButton.primary(
                      label:
                          '${AppStrings.orderNow}  •  \$ ${cartSuccess.total.toStringAsFixed(2)}',
                      height: 52,
                      borderRadius: BorderRadius.circular(18),
                      onPressed: () {
                        context.read<CartCubit>().placeOrder();
                      },
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

class _DeliveryOptionTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryOptionTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryCoffee : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AppText(
              title,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF7E726A),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AddressActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : const Color(0xFFE0D6CE),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.primaryCoffee),
            const SizedBox(width: 4),
            AppText(
              label,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF5A4C42),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkRoast : const Color(0xFFF3ECE6),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFE5DDD5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Icon(
            icon,
            size: 14,
            color: isDark ? Colors.white : const Color(0xFF241913),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final double fontSize;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.fontSize = 13.5,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          color: isBold
              ? (isDark ? Colors.white : const Color(0xFF241913))
              : (isDark ? const Color(0xFFA59B93) : const Color(0xFF7E726A)),
        ),
        AppText(
          value,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
          color: valueColor ??
              (isDark ? Colors.white : const Color(0xFF241913)),
        ),
      ],
    );
  }
}
