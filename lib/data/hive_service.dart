import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_item.dart';
import '../models/meal_entry.dart';
import '../models/nutrition_goal.dart';
import 'food_database.dart';

/// Central Hive storage service for all local data operations
class HiveService {
  static const String mealEntriesBox = 'meal_entries';
  static const String foodItemsBox = 'food_items';
  static const String goalsBox = 'goals';
  static const String settingsBox = 'settings';

  static late Box _mealBox;
  static late Box _foodBox;
  static late Box _goalBox;
  static late Box _settingsBox;

  /// Initialize all Hive boxes and seed food database on first run
  static Future<void> init() async {
    _mealBox = await Hive.openBox(mealEntriesBox);
    _foodBox = await Hive.openBox(foodItemsBox);
    _goalBox = await Hive.openBox(goalsBox);
    _settingsBox = await Hive.openBox(settingsBox);

    // Seed built-in foods on first launch
    if (_foodBox.isEmpty) {
      await _seedFoodDatabase();
    }

    // Set default goal if none exists
    if (_goalBox.isEmpty) {
      await saveGoal(NutritionGoal.defaultGoal());
    }
  }

  static Future<void> _seedFoodDatabase() async {
    final foods = FoodDatabase.getAllFoods();
    for (final food in foods) {
      await _foodBox.put(food.id, food.toMap());
    }
  }

  // === MEAL ENTRY OPERATIONS ===

  static Future<void> addMealEntry(MealEntry entry) async {
    await _mealBox.put(entry.id, entry.toMap());
  }

  static Future<void> deleteMealEntry(String id) async {
    await _mealBox.delete(id);
  }

  static List<MealEntry> getAllMealEntries() {
    return _mealBox.values
        .map((e) => MealEntry.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  static List<MealEntry> getMealEntriesByDate(DateTime date) {
    return getAllMealEntries()
        .where((e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day)
        .toList();
  }

  static List<MealEntry> getMealEntriesByDateRange(
      DateTime start, DateTime end) {
    return getAllMealEntries()
        .where((e) =>
            e.date.isAfter(start.subtract(const Duration(days: 1))) &&
            e.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  static List<MealEntry> getUnsyncedEntries() {
    return getAllMealEntries().where((e) => !e.isSynced).toList();
  }

  static Future<void> markAsSynced(String id) async {
    final map = _mealBox.get(id);
    if (map != null) {
      final entry =
          MealEntry.fromMap(Map<dynamic, dynamic>.from(map));
      final synced = entry.copyWith(isSynced: true);
      await _mealBox.put(id, synced.toMap());
    }
  }

  // === FOOD ITEM OPERATIONS ===

  static List<FoodItem> getAllFoodItems() {
    return _foodBox.values
        .map((e) => FoodItem.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  static Future<void> addCustomFood(FoodItem food) async {
    await _foodBox.put(food.id, food.toMap());
  }

  static FoodItem? getFoodItem(String id) {
    final map = _foodBox.get(id);
    if (map == null) return null;
    return FoodItem.fromMap(Map<dynamic, dynamic>.from(map));
  }

  // === GOAL OPERATIONS ===

  static Future<void> saveGoal(NutritionGoal goal) async {
    await _goalBox.put('current_goal', goal.toMap());
  }

  static NutritionGoal getGoal() {
    final map = _goalBox.get('current_goal');
    if (map == null) return NutritionGoal.defaultGoal();
    return NutritionGoal.fromMap(Map<dynamic, dynamic>.from(map));
  }

  // === SETTINGS ===

  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }
}
