import 'package:flutter/material.dart';
import '../models/meal_entry.dart';
import '../theme/app_theme.dart';

/// Card widget displaying a single meal entry with swipe-to-delete
class MealCard extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback? onDelete;

  const MealCard({
    super.key,
    required this.entry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 26),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // Food icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _mealColor(entry.mealType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  entry.mealType.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Food name and quantity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.foodName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.quantity.toInt()}g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Calories
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.totalCalories.toInt()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGreen,
                      ),
                ),
                Text(
                  'kcal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _mealColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return const Color(0xFFFF9800);
      case MealType.lunch:
        return const Color(0xFF4CAF50);
      case MealType.dinner:
        return const Color(0xFF3F51B5);
      case MealType.snack:
        return const Color(0xFFE91E63);
    }
  }
}
