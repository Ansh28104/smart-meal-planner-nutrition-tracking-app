import 'package:flutter/foundation.dart';
import '../models/nutrition_goal.dart';
import '../data/hive_service.dart';

/// Manages nutrition goal state - setting and comparing targets
class GoalProvider extends ChangeNotifier {
  NutritionGoal _goal = NutritionGoal.defaultGoal();

  NutritionGoal get goal => _goal;

  void loadGoals() {
    _goal = HiveService.getGoal();
    notifyListeners();
  }

  Future<void> saveGoal(NutritionGoal goal) async {
    _goal = goal;
    await HiveService.saveGoal(goal);
    notifyListeners();
  }

  /// Calculate achievement percentage for calories
  double calorieAchievement(double consumed) {
    if (_goal.targetCalories <= 0) return 0;
    return (consumed / _goal.targetCalories * 100).clamp(0, 200);
  }

  /// Calculate achievement percentage for protein
  double? proteinAchievement(double consumed) {
    if (_goal.targetProtein == null || _goal.targetProtein! <= 0) return null;
    return (consumed / _goal.targetProtein! * 100).clamp(0, 200);
  }

  /// Calculate achievement percentage for carbs
  double? carbsAchievement(double consumed) {
    if (_goal.targetCarbs == null || _goal.targetCarbs! <= 0) return null;
    return (consumed / _goal.targetCarbs! * 100).clamp(0, 200);
  }

  /// Calculate achievement percentage for fats
  double? fatsAchievement(double consumed) {
    if (_goal.targetFats == null || _goal.targetFats! <= 0) return null;
    return (consumed / _goal.targetFats! * 100).clamp(0, 200);
  }

  double remainingCalories(double consumed) {
    return (_goal.targetCalories - consumed).clamp(0, double.infinity);
  }
}
