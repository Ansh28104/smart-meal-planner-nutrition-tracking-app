import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';

/// Tile widget for displaying a food item in selection lists with animations
class FoodTile extends StatefulWidget {
  final FoodItem food;
  final VoidCallback? onTap;
  final int index;

  const FoodTile({
    super.key,
    required this.food,
    this.onTap,
    this.index = 0,
  });

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: _isHovered ? 15 : 8,
                offset: Offset(0, _isHovered ? 6 : 2),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _categoryColor(widget.food.category).withValues(alpha: 0.25),
                      _categoryColor(widget.food.category).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    _categoryEmoji(widget.food.category),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Name and category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _nutrientChip('P: ${widget.food.proteinPer100g.toInt()}g', AppTheme.proteinColor),
                        const SizedBox(width: 6),
                        _nutrientChip('C: ${widget.food.carbsPer100g.toInt()}g', AppTheme.carbsColor),
                        const SizedBox(width: 6),
                        _nutrientChip('F: ${widget.food.fatsPer100g.toInt()}g', AppTheme.fatsColor),
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
                    '${widget.food.caloriesPer100g.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                        ),
                  ),
                  Text(
                    'kcal/100g',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.add_circle_rounded,
                color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: _isHovered ? 1.0 : 0.4),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    ).animate()
     .fadeIn(delay: (40 * widget.index).ms, duration: 300.ms)
     .slideY(begin: 0.1, delay: (40 * widget.index).ms, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _nutrientChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  static String _categoryEmoji(String category) {
    switch (category) {
      case 'Grains': return '🌾';
      case 'Protein': return '🥩';
      case 'Dairy': return '🥛';
      case 'Fruits': return '🍎';
      case 'Vegetables': return '🥦';
      case 'Snacks': return '🥜';
      case 'Beverages': return '☕';
      default: return '🍽️';
    }
  }

  static Color _categoryColor(String category) {
    switch (category) {
      case 'Grains': return const Color(0xFFFFB300);
      case 'Protein': return const Color(0xFFFF5252);
      case 'Dairy': return const Color(0xFF448AFF);
      case 'Fruits': return const Color(0xFF69F0AE);
      case 'Vegetables': return const Color(0xFF1DE9B6);
      case 'Snacks': return const Color(0xFFE040FB);
      case 'Beverages': return const Color(0xFF8D6E63);
      default: return Colors.grey;
    }
  }
}
