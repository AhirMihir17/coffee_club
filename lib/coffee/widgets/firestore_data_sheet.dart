import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/app_widgets.dart';
import '../models/coffee_item.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/home/cubit/home_state.dart';
import 'add_coffee_dialog.dart';

class FirestoreDataSheet extends StatelessWidget {
  const FirestoreDataSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: const FirestoreDataSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final homeCubit = context.read<HomeCubit>();
          final coffees =
              state is HomeSuccess ? state.allCoffees : <CoffeeItem>[];
          final isSyncing = state is HomeSuccess && state.isSyncing;
          final expandedDocIds =
              state is HomeSuccess ? state.expandedDocIds : const <String>{};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              // Title and Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCoffee.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppTheme.primaryCoffee,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Cloud Firestore Data',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.foreground(context),
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            'Database: (default) • Collection: coffees (${coffees.length})',
                            fontSize: 12,
                            color: AppTheme.primaryCoffee,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppTheme.muted(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Action Buttons: Re-Seed & Add
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      label: 'Re-Seed 8 Items',
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      height: 42,
                      isLoading: isSyncing,
                      onPressed: () async {
                        await homeCubit.seedDataToFirestore();
                        if (context.mounted) {
                          AppToast.showSuccess(
                            context: context,
                            title: 'Firestore Seeded',
                            message:
                                'Sample data written to Cloud Firestore default database!',
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton.primary(
                      label: 'Add Document',
                      icon: const Icon(Icons.add_rounded,
                          size: 18, color: Colors.white),
                      height: 42,
                      onPressed: () {
                        Navigator.pop(context);
                        AddCoffeeBottomSheet.show(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Divider(color: AppTheme.border(context)),
              const SizedBox(height: 8),

              AppText(
                'Documents in "coffees" Collection:',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted(context),
              ),
              const SizedBox(height: 8),

              // Documents List
              Expanded(
                child: coffees.isEmpty
                    ? Center(
                        child: AppText(
                          'No documents in collection. Tap "Re-Seed" above.',
                          color: AppTheme.muted(context),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: coffees.length,
                        separatorBuilder: (context, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = coffees[index];
                          final isExpanded =
                              expandedDocIds.contains(item.id);

                          return _FirestoreDocCard(
                            item: item,
                            isExpanded: isExpanded,
                            onToggleExpand: () =>
                                homeCubit.toggleDocExpanded(item.id),
                            onDelete: () async {
                              await homeCubit.deleteCoffee(item.id);
                              if (context.mounted) {
                                AppToast.showSuccess(
                                  context: context,
                                  title: 'Deleted from Firestore',
                                  message: '${item.name} removed from DB.',
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FirestoreDocCard extends StatelessWidget {
  final CoffeeItem item;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onDelete;

  const _FirestoreDocCard({
    required this.item,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border(context),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onToggleExpand,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Row(
              children: [
                Expanded(
                  child: AppText(
                    item.name,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.foreground(context),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCoffee.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    '\$${item.price.toStringAsFixed(2)}',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryCoffee,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AppText(
                'doc_id: ${item.id} • category: ${item.category}',
                fontSize: 11,
                color: AppTheme.muted(context),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppTheme.accentHeart, size: 20),
                  onPressed: onDelete,
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.muted(context),
                ),
              ],
            ),
          ),

          // Expanded Types breakdown
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.espressoBlack
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.border(context),
                  ),
                ),
                child: Column(
                  children: [
                    _TypeRow(
                      type: 'String',
                      name: 'name',
                      value: item.name,
                      typeColor: AppTheme.primaryCoffee,
                    ),
                    _TypeRow(
                      type: 'String',
                      name: 'category',
                      value: item.category,
                      typeColor: AppTheme.primaryCoffee,
                    ),
                    _TypeRow(
                      type: 'String',
                      name: 'roastLevel',
                      value: item.roastLevel,
                      typeColor: AppTheme.primaryCoffee,
                    ),
                    _TypeRow(
                      type: 'double',
                      name: 'price',
                      value: item.price.toString(),
                      typeColor: AppTheme.goldenStar,
                    ),
                    _TypeRow(
                      type: 'double',
                      name: 'rating',
                      value: item.rating.toString(),
                      typeColor: AppTheme.goldenStar,
                    ),
                    _TypeRow(
                      type: 'num / int',
                      name: 'reviewCount',
                      value: item.reviewCount.toString(),
                      typeColor: AppTheme.mint,
                    ),
                    _TypeRow(
                      type: 'num / int',
                      name: 'stock',
                      value: item.stock.toString(),
                      typeColor: AppTheme.mint,
                    ),
                    _TypeRow(
                      type: 'num / int',
                      name: 'calories',
                      value: item.calories.toString(),
                      typeColor: AppTheme.mint,
                    ),
                    _TypeRow(
                      type: 'bool',
                      name: 'isPopular',
                      value: item.isPopular.toString(),
                      typeColor: AppTheme.accentHeart,
                    ),
                    _TypeRow(
                      type: 'List<String>',
                      name: 'sizes',
                      value: item.sizes.join(', '),
                      typeColor: AppTheme.primaryDark,
                    ),
                    _TypeRow(
                      type: 'Map<String, double>',
                      name: 'sizePriceOffsets',
                      value: item.sizePriceOffsets.toString(),
                      typeColor: AppTheme.primaryCoffee,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  final String type;
  final String name;
  final String value;
  final Color typeColor;

  const _TypeRow({
    required this.type,
    required this.name,
    required this.value,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: AppText(
              type,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: typeColor,
            ),
          ),
          const SizedBox(width: 8),
          AppText(
            '$name: ',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.muted(context),
          ),
          Expanded(
            child: AppText(
              value,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.foreground(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
