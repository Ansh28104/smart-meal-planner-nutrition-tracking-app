import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/meal_provider.dart';
import '../providers/goal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/calorie_progress_ring.dart';
import '../widgets/nutrient_bar.dart';
import '../models/meal_entry.dart';

/// Screen 3: Daily Tracking - summary of today's intake
class DailyTrackingScreen extends StatelessWidget {
  const DailyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                DateFormat('MMM dd, yyyy').format(today),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        CalorieProgressRing(
                          consumed: consumed,
                          target: target,
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
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
                              const SizedBox(height: 16),
                              NutrientBar(
                                label: 'Protein',
                                consumed: proteinConsumed,
                                target: proteinTarget,
                                color: AppTheme.proteinColor,
                              ),
                              const SizedBox(height: 8),
                              NutrientBar(
                                label: 'Carbs',
                                consumed: carbsConsumed,
                                target: carbsTarget,
                                color: AppTheme.carbsColor,
                              ),
                              const SizedBox(height: 8),
                              NutrientBar(
                                label: 'Fats',
                                consumed: fatsConsumed,
                                target: fatsTarget,
                                color: AppTheme.fatsColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Today\'s Meals',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                  sliver: mealProvider.todayEntries.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(Icons.restaurant_menu, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No meals logged today',
                                    style: TextStyle(color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = mealProvider.todayEntries[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade100),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceLight,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(entry.mealType.icon, style: const TextStyle(fontSize: 20)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.foodName,
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${entry.mealType.displayName} • ${entry.quantity.toInt()}g',
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${entry.totalCalories.toInt()} kcal',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primaryGreen,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
