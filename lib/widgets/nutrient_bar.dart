import 'package:flutter/material.dart';

/// Horizontal progress bar for nutrient tracking (protein, carbs, fats)
class NutrientBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;
  final String unit;

  const NutrientBar({
    super.key,
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  @override
  Widget build(BuildContext context) {
    final percentage = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Text(
                '${consumed.toInt()}$unit / ${target.toInt()}$unit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: color.withOpacity(0.12),
                  color: color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
