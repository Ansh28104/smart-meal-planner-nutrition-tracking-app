import 'package:flutter/foundation.dart';
import '../models/daily_log.dart';
import '../data/hive_service.dart';

/// Provides analytics data - weekly trends, streaks, averages
class AnalyticsProvider extends ChangeNotifier {
  /// Get daily logs for the past N days
  List<DailyLog> getDailyLogs(int days) {
    final now = DateTime.now();
    final logs = <DailyLog>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final entries = HiveService.getMealEntriesByDate(date);

      logs.add(
        DailyLog(
          date: date,
          totalCalories: entries.fold(0.0, (s, e) => s + e.totalCalories),
          totalProtein: entries.fold(0.0, (s, e) => s + e.totalProtein),
          totalCarbs: entries.fold(0.0, (s, e) => s + e.totalCarbs),
          totalFats: entries.fold(0.0, (s, e) => s + e.totalFats),
          mealCount: entries.length,
        ),
      );
    }

    return logs;
  }

  /// Get weekly calorie data (last 7 days)
  List<DailyLog> get weeklyData => getDailyLogs(7);

  /// Average daily calories over the past week
  double get weeklyAvgCalories {
    final logs = weeklyData;
    if (logs.isEmpty) return 0;
    final total = logs.fold(0.0, (s, l) => s + l.totalCalories);
    return total / logs.length;
  }

  /// Goal achievement streak (consecutive days meeting calorie target)
  int goalStreak(double targetCalories) {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 1; i <= 30; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      final entries = HiveService.getMealEntriesByDate(date);
      final dayCalories = entries.fold(0.0, (s, e) => s + e.totalCalories);

      // Consider within 10% of target as meeting goal
      if (dayCalories >= targetCalories * 0.8 &&
          dayCalories <= targetCalories * 1.1 &&
          entries.isNotEmpty) {
        streak++;
      } else if (entries.isNotEmpty) {
        break;
      }
    }

    return streak;
  }

  /// Best day in last 7 days (closest to goal)
  DailyLog? bestDay(double targetCalories) {
    final logs = weeklyData.where((l) => l.mealCount > 0).toList();
    if (logs.isEmpty) return null;

    logs.sort((a, b) {
      final diffA = (a.totalCalories - targetCalories).abs();
      final diffB = (b.totalCalories - targetCalories).abs();
      return diffA.compareTo(diffB);
    });

    return logs.first;
  }

  /// Weekly goal achievement percentage
  double weeklyGoalAchievement(double targetCalories) {
    final logs = weeklyData.where((l) => l.mealCount > 0).toList();
    if (logs.isEmpty) return 0;

    int metGoal = 0;
    for (final log in logs) {
      if (log.totalCalories >= targetCalories * 0.8 &&
          log.totalCalories <= targetCalories * 1.1) {
        metGoal++;
      }
    }

    return (metGoal / logs.length * 100);
  }

  void refresh() {
    notifyListeners();
  }
}
