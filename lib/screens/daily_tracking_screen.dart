import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/meal_provider.dart';
import '../providers/goal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/calorie_progress_ring.dart';
import '../widgets/nutrient_bar.dart';

/// Screen 3: Daily Tracking - summary of today's intake with premium animations
class DailyTrackingScreen extends StatelessWidget {
  const DailyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Consumer2<MealProvider, GoalProvider>(
          builder: (context, mealProvider, goalProvider, _) {
            final today = mealProvider.selectedDate;
            final consumed = mealProvider.todayCalories;
            final target = goalProvider.goal.targetCalories;
            final proteinConsumed = mealProvider.todayProtein;
            final proteinTarget = goalProvider.goal.targetProtein ?? 50.0;
            final carbsConsumed = mealProvider.todayCarbs;
            final carbsTarget = goalProvider.goal.targetCarbs ?? 250.0;
            final fatsConsumed = mealProvider.todayFats;
            final fatsTarget = goalProvider.goal.targetFats ?? 65.0;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Tracking',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.cardDark : AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                DateFormat('MMM dd, yyyy').format(today),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: -0.1),
                        const SizedBox(height: 40),
                        
                        CalorieProgressRing(
                          consumed: consumed,
                          target: target,
                        ).animate().fadeIn(delay: 200.ms, duration: 800.ms).scaleXY(begin: 0.9, curve: Curves.easeOutBack),
                        
                        const SizedBox(height: 48),
                        
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Macronutrients',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              NutrientBar(
                                label: 'Protein',
                                consumed: proteinConsumed,
                                target: proteinTarget,
                                color: AppTheme.proteinColor,
                              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                              const SizedBox(height: 16),
                              NutrientBar(
                                label: 'Carbs',
                                consumed: carbsConsumed,
                                target: carbsTarget,
                                color: AppTheme.carbsColor,
                              ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
                              const SizedBox(height: 16),
                              NutrientBar(
                                label: 'Fats',
                                consumed: fatsConsumed,
                                target: fatsTarget,
                                color: AppTheme.fatsColor,
                              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Today\'s Meals',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn(delay: 600.ms),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                  sliver: mealProvider.todayEntries.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(Icons.restaurant_menu, size: 64, color: isDark ? Colors.white12 : Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No meals logged today',
                                    style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade500, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(delay: 700.ms),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = mealProvider.todayEntries[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.cardDark : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(entry.mealType.icon, style: const TextStyle(fontSize: 24)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.foodName,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${entry.mealType.displayName} • ${entry.quantity.toInt()}g',
                                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${entry.totalCalories.toInt()} kcal',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(delay: (700 + (index * 100)).ms).slideX(begin: 0.1);
                            },
                            childCount: mealProvider.todayEntries.length,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
