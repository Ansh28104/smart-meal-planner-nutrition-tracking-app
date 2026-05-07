import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/meal_entry.dart';
import '../models/food_item.dart';
import '../data/hive_service.dart';

/// Manages meal planning state - adding, removing, and querying meal entries
class MealProvider extends ChangeNotifier {
  List<MealEntry> _entries = [];
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  List<MealEntry> get entries => _entries;
  DateTime get selectedDate => _selectedDate;

  /// Entries filtered to the currently selected date
  List<MealEntry> get todayEntries => _entries
      .where((e) =>
          e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day)
      .toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));

  /// Get entries for a specific meal type on the selected date
  List<MealEntry> entriesForMealType(MealType type) =>
      todayEntries.where((e) => e.mealType == type).toList();

  /// Daily calorie total for selected date
  double get todayCalories =>
      todayEntries.fold(0.0, (sum, e) => sum + e.totalCalories);

  double get todayProtein =>
      todayEntries.fold(0.0, (sum, e) => sum + e.totalProtein);

  double get todayCarbs =>
      todayEntries.fold(0.0, (sum, e) => sum + e.totalCarbs);

  double get todayFats =>
      todayEntries.fold(0.0, (sum, e) => sum + e.totalFats);

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Load all entries from Hive
  void loadMeals() {
    _entries = HiveService.getAllMealEntries();
    notifyListeners();
  }

  /// Add a food item as a meal entry
  Future<void> addMeal({
    required FoodItem food,
    required MealType mealType,
    required double quantity,
  }) async {
    final entry = MealEntry(
      id: _uuid.v4(),
      foodItemId: food.id,
      foodName: food.name,
      mealType: mealType,
      quantity: quantity,
      totalCalories: food.caloriesForQuantity(quantity),
      totalProtein: food.proteinForQuantity(quantity),
      totalCarbs: food.carbsForQuantity(quantity),
      totalFats: food.fatsForQuantity(quantity),
      date: _selectedDate,
      isSynced: false,
    );

    await HiveService.addMealEntry(entry);
    _entries.add(entry);
    notifyListeners();
  }

  /// Update an existing meal entry (e.g., change quantity)
  Future<void> updateMeal(MealEntry updatedEntry) async {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      final entryToSave = updatedEntry.copyWith(isSynced: false);
      await HiveService.addMealEntry(entryToSave);
      _entries[index] = entryToSave;
      notifyListeners();
    }
  }

  /// Delete a meal entry
  Future<void> deleteMeal(String id) async {
    await HiveService.deleteMealEntry(id);
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Get entries for a date range
  List<MealEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return _entries
        .where((e) =>
            e.date.isAfter(start.subtract(const Duration(days: 1))) &&
            e.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  /// Get calorie total for a specific date
  double caloriesForDate(DateTime date) {
    return _entries
        .where((e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day)
        .fold(0.0, (sum, e) => sum + e.totalCalories);
  }
}
