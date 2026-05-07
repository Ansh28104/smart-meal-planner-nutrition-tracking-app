import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/goal_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/weekly_chart.dart';

/// Screen 4: Analytics Dashboard - weekly trends and statistics
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<AnalyticsProvider, GoalProvider>(
          builder: (context, analytics, goalProvider, _) {
            final target = goalProvider.goal.targetCalories;
            final weeklyData = analytics.weeklyData.reversed.toList();
            final avgCalories = analytics.weeklyAvgCalories;
            final streak = analytics.goalStreak(target);
            final achievement = analytics.weeklyGoalAchievement(target);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Analytics Dashboard', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  
                  // Weekly Chart Card
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Weekly Calorie Trend', style: Theme.of(context).textTheme.titleLarge),
                            Icon(Icons.show_chart, color: AppTheme.textSecondary),
                          ],
                        ),
                        const SizedBox(height: 24),
                        WeeklyChart(data: weeklyData, targetCalories: target),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(child: _StatCard(title: 'Goal Streak', value: '$streak', unit: 'days', icon: Icons.local_fire_department, color: AppTheme.secondaryOrange)),
                      const SizedBox(width: 16),
                      Expanded(child: _StatCard(title: 'Avg Intake', value: '${avgCalories.toInt()}', unit: 'kcal/day', icon: Icons.restaurant, color: AppTheme.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Achievement Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryDark, AppTheme.primaryGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 8),
                          ),
                          child: Center(
                            child: Text(
                              '${achievement.toInt()}%',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Weekly Achievement', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('You met your calorie goal on ${(achievement / 100 * 7).round()} out of 7 days.', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.unit, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
