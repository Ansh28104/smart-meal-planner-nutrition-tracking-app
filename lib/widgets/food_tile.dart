import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';

/// Tile widget for displaying a food item in selection lists
class FoodTile extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;

  const FoodTile({
    super.key,
    required this.food,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _categoryColor(food.category).withOpacity(0.15),
                    _categoryColor(food.category).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _categoryEmoji(food.category),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name and category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _nutrientChip('P: ${food.proteinPer100g.toInt()}g',
                          AppTheme.proteinColor),
                      const SizedBox(width: 6),
                      _nutrientChip('C: ${food.carbsPer100g.toInt()}g',
                          AppTheme.carbsColor),
                      const SizedBox(width: 6),
                      _nutrientChip('F: ${food.fatsPer100g.toInt()}g',
                          AppTheme.fatsColor),
                    ],
                  ),
                ],
              ),
            ),
            // Calories per 100g
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${food.caloriesPer100g.toInt()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGreen,
                      ),
                ),
                Text(
                  'kcal/100g',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.add_circle_outline,
                color: AppTheme.primaryGreen.withOpacity(0.6), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _nutrientChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  static String _categoryEmoji(String category) {
    switch (category) {
      case 'Grains':
        return '🌾';
      case 'Protein':
        return '🥩';
      case 'Dairy':
        return '🥛';
      case 'Fruits':
        return '🍎';
      case 'Vegetables':
        return '🥦';
      case 'Snacks':
        return '🥜';
      case 'Beverages':
        return '☕';
      default:
        return '🍽️';
    }
  }

  static Color _categoryColor(String category) {
    switch (category) {
      case 'Grains':
        return const Color(0xFFFF9800);
      case 'Protein':
        return const Color(0xFFE53935);
      case 'Dairy':
        return const Color(0xFF42A5F5);
      case 'Fruits':
        return const Color(0xFF66BB6A);
      case 'Vegetables':
        return const Color(0xFF26A69A);
      case 'Snacks':
        return const Color(0xFFAB47BC);
      case 'Beverages':
        return const Color(0xFF8D6E63);
      default:
        return Colors.grey;
    }
  }
}
