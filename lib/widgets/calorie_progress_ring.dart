import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated circular progress ring with glowing shadows and flutter_animate
class CalorieProgressRing extends StatelessWidget {
  final double consumed;
  final double target;
  final double size;
  final double strokeWidth;

  const CalorieProgressRing({
    super.key,
    required this.consumed,
    required this.target,
    this.size = 200,
    this.strokeWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = target > 0 ? (consumed / target).clamp(0.0, 1.5) : 0.0;
    final remaining = (target - consumed).clamp(0, double.infinity);
    final isOver = consumed > target;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isOver
        ? const Color(0xFFEF4444)
        : valueColorForPercentage(percentage);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glowing Shadow
          Container(
            width: size - strokeWidth,
            height: size - strokeWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scaleXY(begin: 1.0, end: 1.05, duration: 1500.ms, curve: Curves.easeInOut),

          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
              strokeCap: StrokeCap.round,
            ),
          ),
          
          // Progress ring
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage.toDouble()),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutExpo,
            builder: (context, value, _) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  strokeWidth: strokeWidth,
                  color: baseColor,
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
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutExpo,
                builder: (context, value, _) {
                  return Text(
                    '${value.toInt()}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: isOver ? const Color(0xFFEF4444) : (isDark ? Colors.white : Colors.black87),
                          height: 1.1,
                          letterSpacing: -1.5,
                        ),
                  );
                },
              ),
              Text(
                'kcal consumed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isOver ? '+${(consumed - target).toInt()} over' : '${remaining.toInt()} left',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: baseColor,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scaleXY(begin: 0.8),
        ],
      ),
    );
  }

  Color valueColorForPercentage(num percentage) {
    if (percentage > 0.8) return const Color(0xFFFFB300);
    return const Color(0xFF00E676);
  }
}
