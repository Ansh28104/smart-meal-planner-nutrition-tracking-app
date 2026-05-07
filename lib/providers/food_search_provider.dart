import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/meal_entry.dart';
import '../data/hive_service.dart';

/// Manages food search and meal entry filtering
class FoodSearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  String? _selectedCategory;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  MealType? _filterMealType;

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;
  MealType? get filterMealType => _filterMealType;

  /// Search food items from Hive storage
  List<FoodItem> get searchResults {
    List<FoodItem> foods = HiveService.getAllFoodItems();

    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      foods = foods
          .where((f) =>
              f.name.toLowerCase().contains(lower) ||
              f.category.toLowerCase().contains(lower))
          .toList();
    }

    if (_selectedCategory != null) {
      foods = foods.where((f) => f.category == _selectedCategory).toList();
    }

    return foods;
  }

  /// Filter meal entries by date range and meal type
  List<MealEntry> get filteredMealEntries {
    List<MealEntry> entries = HiveService.getAllMealEntries();

    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      entries = entries
          .where((e) => e.foodName.toLowerCase().contains(lower))
          .toList();
    }

    if (_filterStartDate != null && _filterEndDate != null) {
      entries = entries
          .where((e) =>
              e.date.isAfter(
                  _filterStartDate!.subtract(const Duration(days: 1))) &&
              e.date
                  .isBefore(_filterEndDate!.add(const Duration(days: 1))))
          .toList();
    } else if (_filterStartDate != null) {
      entries = entries
          .where((e) => e.date.isAfter(
              _filterStartDate!.subtract(const Duration(days: 1))))
          .toList();
    }

    if (_filterMealType != null) {
      entries =
          entries.where((e) => e.mealType == _filterMealType).toList();
    }

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _filterStartDate = start;
    _filterEndDate = end;
    notifyListeners();
  }

  void setMealTypeFilter(MealType? type) {
    _filterMealType = type;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _filterMealType = null;
    notifyListeners();
  }
}
