import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import '../screens/home/cubit/home_cubit.dart';
import 'cubit/add_coffee_cubit.dart';
import 'cubit/add_coffee_state.dart';

class AddCoffeeBottomSheet extends StatefulWidget {
  const AddCoffeeBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<HomeCubit>()),
          BlocProvider(create: (_) => AddCoffeeCubit()),
        ],
        child: const AddCoffeeBottomSheet(),
      ),
    );
  }

  @override
  State<AddCoffeeBottomSheet> createState() => _AddCoffeeBottomSheetState();
}

class _AddCoffeeBottomSheetState extends State<AddCoffeeBottomSheet> {
  // Purely controller holders for text field lifecycle - ZERO setState in this file
  late final TextEditingController _nameController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _ratingController;
  late final TextEditingController _reviewCountController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _stockController;
  late final TextEditingController _categoryController;
  late final TextEditingController _roastController;

  static const List<String> _commonCategories = [
    'Latte',
    'Machiato',
    'Cappuccino',
    'Espresso',
    'Cold Brew',
    'Bakery',
  ];

  static const List<String> _commonRoasts = [
    'Medium Roast',
    'Dark Roast',
    'Arabica Blend',
    'Single Origin',
    'Cold Extraction',
  ];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddCoffeeCubit>();
    final state = cubit.state;
    _nameController = TextEditingController(text: state.name);
    _subtitleController = TextEditingController(text: state.subtitle);
    _descriptionController = TextEditingController(text: state.description);
    _priceController = TextEditingController(text: state.priceText);
    _ratingController = TextEditingController(text: state.ratingText);
    _reviewCountController = TextEditingController(text: state.reviewCountText);
    _caloriesController = TextEditingController(text: state.caloriesText);
    _stockController = TextEditingController(text: state.stockText);
    _categoryController = TextEditingController(text: state.category);
    _roastController = TextEditingController(text: state.roastLevel);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _reviewCountController.dispose();
    _caloriesController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _roastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<AddCoffeeCubit, AddCoffeeState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppToast.showError(
            context: context,
            title: 'Validation Error',
            message: state.errorMessage!,
          );
          context.read<AddCoffeeCubit>().clearError();
        }

        if (state.isSuccess) {
          AppToast.showSuccess(
            context: context,
            title: 'Stored in Firestore!',
            message: '${_nameController.text.trim()} stored in "coffees" collection.',
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddCoffeeCubit>();

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
          decoration: BoxDecoration(
            color: AppTheme.surfaceBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.muted(context).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCoffee.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_rounded,
                        color: AppTheme.primaryCoffee,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Add Coffee to Firestore',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.foreground(context),
                          ),
                          const SizedBox(height: 2),
                          const AppText(
                            'Stores String, double, num, bool, Map & Array in DB',
                            fontSize: 12,
                            color: AppTheme.primaryCoffee,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Coffee Name Field (String)
                AppText(
                  'Coffee Name (String)',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted(context),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _nameController,
                  hintText: 'e.g. Caramel Macchiato',
                  prefixIcon: Icons.coffee_rounded,
                  onChanged: cubit.updateName,
                  style: TextStyle(
                    color: AppTheme.foreground(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),

                // Subtitle Field (String)
                AppText(
                  'Subtitle (String)',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted(context),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _subtitleController,
                  hintText: 'e.g. With Salted Caramel Drizzle',
                  prefixIcon: Icons.subtitles_outlined,
                  onChanged: cubit.updateSubtitle,
                  style: TextStyle(
                    color: AppTheme.foreground(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),

                // Category Field (String)
                AppText(
                  'Category (String)',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted(context),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _categoryController,
                  hintText: 'e.g. Latte',
                  prefixIcon: Icons.category_outlined,
                  onChanged: cubit.updateCategory,
                  style: TextStyle(
                    color: AppTheme.foreground(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _commonCategories.map((cat) {
                    final isSelected = state.category == cat;
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        _categoryController.text = cat;
                        cubit.updateCategory(cat);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryCoffee
                              : AppTheme.cardBackground(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryCoffee
                                : AppTheme.border(context),
                          ),
                        ),
                        child: AppText(
                          cat,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.foreground(context),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Description Field (String)
                AppText(
                  'Description (String)',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted(context),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _descriptionController,
                  hintText: 'Freshly steamed milk with aromatic roast...',
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 2,
                  onChanged: cubit.updateDescription,
                  style: TextStyle(
                    color: AppTheme.foreground(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),

                // Price (double) & Rating (double)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Price (\$ double)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _priceController,
                            hintText: '4.50',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixIcon: Icons.attach_money_rounded,
                            onChanged: cubit.updatePrice,
                            style: TextStyle(
                              color: AppTheme.foreground(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Rating (double)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _ratingController,
                            hintText: '4.8',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixIcon: Icons.star_rounded,
                            onChanged: cubit.updateRating,
                            style: TextStyle(
                              color: AppTheme.foreground(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Review Count (int/num) & Calories (int/num)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Reviews (int num)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _reviewCountController,
                            hintText: '120',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.rate_review_outlined,
                            onChanged: cubit.updateReviewCount,
                            style: TextStyle(
                              color: AppTheme.foreground(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Calories (int num)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _caloriesController,
                            hintText: '180',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.local_fire_department_outlined,
                            onChanged: cubit.updateCalories,
                            style: TextStyle(
                              color: AppTheme.foreground(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Stock (int/num) & Roast Level (String)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Stock (int num)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          AppTextField(
                            controller: _stockController,
                            hintText: '50',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.inventory_2_outlined,
                            onChanged: cubit.updateStock,
                            style: TextStyle(
                              color: AppTheme.foreground(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Popular (bool)',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted(context),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBackground(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppTheme.border(context),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  state.isPopular ? 'Featured' : 'Standard',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.foreground(context),
                                ),
                                AppSwitch(
                                  value: state.isPopular,
                                  onChanged: cubit.togglePopular,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Roast Level Field (String)
                AppText(
                  'Roast Level (String)',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.muted(context),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _roastController,
                  hintText: 'e.g. Medium Roast',
                  prefixIcon: Icons.local_fire_department_outlined,
                  onChanged: cubit.updateRoastLevel,
                  style: TextStyle(
                    color: AppTheme.foreground(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _commonRoasts.map((roast) {
                    final isSelected = state.roastLevel == roast;
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        _roastController.text = roast;
                        cubit.updateRoastLevel(roast);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryCoffee
                              : AppTheme.cardBackground(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryCoffee
                                : AppTheme.border(context),
                          ),
                        ),
                        child: AppText(
                          roast,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.foreground(context),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Submit Button
                AppButton.primary(
                  label: 'Save to Cloud Firestore',
                  isLoading: state.isLoading,
                  icon: const Icon(Icons.cloud_upload_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    cubit.submit(context.read<HomeCubit>());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
