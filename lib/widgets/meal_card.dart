import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/meal_entry.dart';
import '../theme/app_theme.dart';

/// Card widget displaying a single meal entry with swipe-to-delete and animations
class MealCard extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback? onDelete;
  final int index; // Used for staggered animations

  const MealCard({
    super.key,
    required this.entry,
    this.onDelete,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.danger.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: AppTheme.danger, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _mealColor(entry.mealType).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  entry.mealType.icon,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Food name and quantity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.foodName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
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
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                      ),
                ),
                Text(
                  'kcal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(delay: (50 * index).ms, duration: 400.ms)
     .slideX(begin: 0.05, delay: (50 * index).ms, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  Color _mealColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return const Color(0xFFFFB300);
      case MealType.lunch:
        return const Color(0xFF00E676);
      case MealType.dinner:
        return const Color(0xFF536DFE);
      case MealType.snack:
        return const Color(0xFFFF4081);
    }
  }
}
