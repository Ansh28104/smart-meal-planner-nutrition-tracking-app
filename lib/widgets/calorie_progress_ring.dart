import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated circular progress ring for calorie tracking
class CalorieProgressRing extends StatelessWidget {
  final double consumed;
  final double target;
  final double size;
  final double strokeWidth;

  const CalorieProgressRing({
    super.key,
    required this.consumed,
    required this.target,
    this.size = 180,
    this.strokeWidth = 14,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = target > 0 ? (consumed / target).clamp(0.0, 1.5) : 0.0;
    final remaining = (target - consumed).clamp(0, double.infinity);
    final isOver = consumed > target;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: Colors.grey.shade200,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Progress ring
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage.toDouble()),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  strokeWidth: strokeWidth,
                  color: isOver
                      ? AppTheme.danger
                      : value > 0.8
                          ? AppTheme.warning
                          : AppTheme.primaryGreen,
                  strokeCap: StrokeCap.round,
                ),
              );
            },
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: consumed),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, _) {
                  return Text(
                    '${value.toInt()}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isOver ? AppTheme.danger : AppTheme.textPrimary,
                        ),
                  );
                },
              ),
              Text(
                'kcal consumed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isOver
                      ? AppTheme.danger.withOpacity(0.1)
                      : AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOver
                      ? '+${(consumed - target).toInt()} over'
                      : '${remaining.toInt()} left',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOver ? AppTheme.danger : AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
