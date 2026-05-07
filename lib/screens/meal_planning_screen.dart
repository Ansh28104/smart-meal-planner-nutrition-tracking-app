import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/meal_entry.dart';
import '../providers/meal_provider.dart';
import '../providers/goal_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/meal_card.dart';
import 'food_selection_screen.dart';
import 'goal_setting_screen.dart';

/// Screen 1: Meal Planning - plan daily meals by type with premium UI
class MealPlanningScreen extends StatelessWidget {
  const MealPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Consumer2<MealProvider, GoalProvider>(
          builder: (context, mealProvider, goalProvider, _) {
            final todayCal = mealProvider.todayCalories;
            final targetCal = goalProvider.goal.targetCalories;
            final percentage = targetCal > 0 ? (todayCal / targetCal * 100).clamp(0, 200) : 0;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meal Planner',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Plan your meals for the day',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeProvider>().toggleTheme();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.primaryGreen.withValues(alpha: 0.15) : AppTheme.primaryDark.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                  color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const GoalSettingScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.primaryGreen.withValues(alpha: 0.15) : AppTheme.primaryDark.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.flag_rounded,
                                  color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
                  ),
                ),

                // Date Selector
                SliverToBoxAdapter(
                  child: _DateSelector(
                    selectedDate: mealProvider.selectedDate,
                    onDateChanged: mealProvider.setSelectedDate,
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),
                ),

                // Calorie Summary Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [AppTheme.primaryDark, AppTheme.primaryGreen]
                              : [AppTheme.primaryDark, const Color(0xFF00E676)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daily Progress',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${todayCal.toInt()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4, left: 6),
                                      child: Text(
                                        '/ ${targetCal.toInt()} kcal',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: percentage.toDouble() / 100),
                                    duration: const Duration(milliseconds: 1000),
                                    curve: Curves.easeOutExpo,
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value.clamp(0.0, 1.0),
                                        minHeight: 10,
                                        backgroundColor: Colors.black.withValues(alpha: 0.15),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${percentage.toInt()}% of daily goal',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${percentage.toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                           .scaleXY(begin: 1.0, end: 1.05, duration: 2.seconds, curve: Curves.easeInOut),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                ),

                // Meal Type Sections
                ...MealType.values.asMap().entries.map((entryItem) {
                  final sectionIndex = entryItem.key;
                  final type = entryItem.value;
                  final meals = mealProvider.entriesForMealType(type);
                  final mealCalories = meals.fold(0.0, (s, e) => s + e.totalCalories);

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    type.icon,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    type.displayName,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 10),
                                  if (mealCalories > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${mealCalories.toInt()} kcal',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => FoodSelectionScreen(mealType: type)),
                                  );
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (meals.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 38, bottom: 8, top: 4),
                              child: Text(
                                'No items added yet',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                              ),
                            )
                          else
                            ...meals.asMap().entries.map((m) => MealCard(
                                  entry: m.value,
                                  index: m.key,
                                  onDelete: () {
                                    mealProvider.deleteMeal(m.value.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${m.value.foodName} removed')),
                                    );
                                  },
                                )),
                        ],
                      ).animate().fadeIn(delay: (300 + (sectionIndex * 100)).ms).slideY(begin: 0.1),
                    ),
                  );
                }),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Horizontal date selector with day chips
class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DateSelector({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.primaryGreen : AppTheme.primaryDark;

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime(today.year, today.month, today.day - 7 + index);
          final isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;
          final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

          return GestureDetector(
            onTap: () => onDateChanged(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              width: 56,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : isToday
                        ? primaryColor.withValues(alpha: 0.1)
                        : (isDark ? AppTheme.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(18),
                border: isToday && !isSelected ? Border.all(color: primaryColor.withValues(alpha: 0.5), width: 1.5) : null,
                boxShadow: isSelected
                    ? [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))]
                    : [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 2),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? (isDark ? AppTheme.surfaceDark : Colors.white) : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? (isDark ? AppTheme.surfaceDark : Colors.white) : (isDark ? Colors.white : AppTheme.textPrimaryLight),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
