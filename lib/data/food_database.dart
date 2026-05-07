import '../models/food_item.dart';

/// Built-in food database with ~50 common food items
/// All values are per 100 grams
class FoodDatabase {
  static List<FoodItem> getAllFoods() {
    return [
      // === GRAINS & CEREALS ===
      FoodItem(id: 'f001', name: 'White Rice (cooked)', caloriesPer100g: 130, proteinPer100g: 2.7, carbsPer100g: 28, fatsPer100g: 0.3, category: 'Grains'),
      FoodItem(id: 'f002', name: 'Brown Rice (cooked)', caloriesPer100g: 112, proteinPer100g: 2.6, carbsPer100g: 23, fatsPer100g: 0.9, category: 'Grains'),
      FoodItem(id: 'f003', name: 'Whole Wheat Bread', caloriesPer100g: 247, proteinPer100g: 13, carbsPer100g: 41, fatsPer100g: 3.4, category: 'Grains'),
      FoodItem(id: 'f004', name: 'Oats (dry)', caloriesPer100g: 389, proteinPer100g: 17, carbsPer100g: 66, fatsPer100g: 6.9, category: 'Grains'),
      FoodItem(id: 'f005', name: 'Pasta (cooked)', caloriesPer100g: 131, proteinPer100g: 5, carbsPer100g: 25, fatsPer100g: 1.1, category: 'Grains'),
      FoodItem(id: 'f006', name: 'Quinoa (cooked)', caloriesPer100g: 120, proteinPer100g: 4.4, carbsPer100g: 21, fatsPer100g: 1.9, category: 'Grains'),
      FoodItem(id: 'f007', name: 'Corn Tortilla', caloriesPer100g: 218, proteinPer100g: 5.7, carbsPer100g: 44, fatsPer100g: 2.8, category: 'Grains'),
      FoodItem(id: 'f008', name: 'Roti / Chapati', caloriesPer100g: 297, proteinPer100g: 9.8, carbsPer100g: 50, fatsPer100g: 7.5, category: 'Grains'),

      // === PROTEINS ===
      FoodItem(id: 'f009', name: 'Chicken Breast (grilled)', caloriesPer100g: 165, proteinPer100g: 31, carbsPer100g: 0, fatsPer100g: 3.6, category: 'Protein'),
      FoodItem(id: 'f010', name: 'Eggs (boiled)', caloriesPer100g: 155, proteinPer100g: 13, carbsPer100g: 1.1, fatsPer100g: 11, category: 'Protein'),
      FoodItem(id: 'f011', name: 'Salmon (baked)', caloriesPer100g: 208, proteinPer100g: 20, carbsPer100g: 0, fatsPer100g: 13, category: 'Protein'),
      FoodItem(id: 'f012', name: 'Tuna (canned)', caloriesPer100g: 132, proteinPer100g: 29, carbsPer100g: 0, fatsPer100g: 1, category: 'Protein'),
      FoodItem(id: 'f013', name: 'Tofu (firm)', caloriesPer100g: 76, proteinPer100g: 8, carbsPer100g: 1.9, fatsPer100g: 4.8, category: 'Protein'),
      FoodItem(id: 'f014', name: 'Lentils (cooked)', caloriesPer100g: 116, proteinPer100g: 9, carbsPer100g: 20, fatsPer100g: 0.4, category: 'Protein'),
      FoodItem(id: 'f015', name: 'Chickpeas (cooked)', caloriesPer100g: 164, proteinPer100g: 8.9, carbsPer100g: 27, fatsPer100g: 2.6, category: 'Protein'),
      FoodItem(id: 'f016', name: 'Paneer', caloriesPer100g: 265, proteinPer100g: 18, carbsPer100g: 1.2, fatsPer100g: 21, category: 'Protein'),
      FoodItem(id: 'f017', name: 'Turkey Breast', caloriesPer100g: 135, proteinPer100g: 30, carbsPer100g: 0, fatsPer100g: 1, category: 'Protein'),
      FoodItem(id: 'f018', name: 'Shrimp (cooked)', caloriesPer100g: 99, proteinPer100g: 24, carbsPer100g: 0.2, fatsPer100g: 0.3, category: 'Protein'),

      // === DAIRY ===
      FoodItem(id: 'f019', name: 'Whole Milk', caloriesPer100g: 61, proteinPer100g: 3.2, carbsPer100g: 4.8, fatsPer100g: 3.3, category: 'Dairy'),
      FoodItem(id: 'f020', name: 'Greek Yogurt', caloriesPer100g: 59, proteinPer100g: 10, carbsPer100g: 3.6, fatsPer100g: 0.7, category: 'Dairy'),
      FoodItem(id: 'f021', name: 'Cheddar Cheese', caloriesPer100g: 403, proteinPer100g: 25, carbsPer100g: 1.3, fatsPer100g: 33, category: 'Dairy'),
      FoodItem(id: 'f022', name: 'Cottage Cheese', caloriesPer100g: 98, proteinPer100g: 11, carbsPer100g: 3.4, fatsPer100g: 4.3, category: 'Dairy'),
      FoodItem(id: 'f023', name: 'Butter', caloriesPer100g: 717, proteinPer100g: 0.9, carbsPer100g: 0.1, fatsPer100g: 81, category: 'Dairy'),

      // === FRUITS ===
      FoodItem(id: 'f024', name: 'Apple', caloriesPer100g: 52, proteinPer100g: 0.3, carbsPer100g: 14, fatsPer100g: 0.2, category: 'Fruits'),
      FoodItem(id: 'f025', name: 'Banana', caloriesPer100g: 89, proteinPer100g: 1.1, carbsPer100g: 23, fatsPer100g: 0.3, category: 'Fruits'),
      FoodItem(id: 'f026', name: 'Orange', caloriesPer100g: 47, proteinPer100g: 0.9, carbsPer100g: 12, fatsPer100g: 0.1, category: 'Fruits'),
      FoodItem(id: 'f027', name: 'Mango', caloriesPer100g: 60, proteinPer100g: 0.8, carbsPer100g: 15, fatsPer100g: 0.4, category: 'Fruits'),
      FoodItem(id: 'f028', name: 'Strawberries', caloriesPer100g: 32, proteinPer100g: 0.7, carbsPer100g: 7.7, fatsPer100g: 0.3, category: 'Fruits'),
      FoodItem(id: 'f029', name: 'Blueberries', caloriesPer100g: 57, proteinPer100g: 0.7, carbsPer100g: 14, fatsPer100g: 0.3, category: 'Fruits'),
      FoodItem(id: 'f030', name: 'Avocado', caloriesPer100g: 160, proteinPer100g: 2, carbsPer100g: 8.5, fatsPer100g: 15, category: 'Fruits'),
      FoodItem(id: 'f031', name: 'Watermelon', caloriesPer100g: 30, proteinPer100g: 0.6, carbsPer100g: 7.6, fatsPer100g: 0.2, category: 'Fruits'),

      // === VEGETABLES ===
      FoodItem(id: 'f032', name: 'Broccoli', caloriesPer100g: 34, proteinPer100g: 2.8, carbsPer100g: 7, fatsPer100g: 0.4, category: 'Vegetables'),
      FoodItem(id: 'f033', name: 'Spinach', caloriesPer100g: 23, proteinPer100g: 2.9, carbsPer100g: 3.6, fatsPer100g: 0.4, category: 'Vegetables'),
      FoodItem(id: 'f034', name: 'Carrot', caloriesPer100g: 41, proteinPer100g: 0.9, carbsPer100g: 10, fatsPer100g: 0.2, category: 'Vegetables'),
      FoodItem(id: 'f035', name: 'Tomato', caloriesPer100g: 18, proteinPer100g: 0.9, carbsPer100g: 3.9, fatsPer100g: 0.2, category: 'Vegetables'),
      FoodItem(id: 'f036', name: 'Sweet Potato (baked)', caloriesPer100g: 90, proteinPer100g: 2, carbsPer100g: 21, fatsPer100g: 0.1, category: 'Vegetables'),
      FoodItem(id: 'f037', name: 'Potato (boiled)', caloriesPer100g: 87, proteinPer100g: 1.9, carbsPer100g: 20, fatsPer100g: 0.1, category: 'Vegetables'),
      FoodItem(id: 'f038', name: 'Cucumber', caloriesPer100g: 15, proteinPer100g: 0.7, carbsPer100g: 3.6, fatsPer100g: 0.1, category: 'Vegetables'),
      FoodItem(id: 'f039', name: 'Bell Pepper', caloriesPer100g: 31, proteinPer100g: 1, carbsPer100g: 6, fatsPer100g: 0.3, category: 'Vegetables'),
      FoodItem(id: 'f040', name: 'Onion', caloriesPer100g: 40, proteinPer100g: 1.1, carbsPer100g: 9.3, fatsPer100g: 0.1, category: 'Vegetables'),

      // === SNACKS & NUTS ===
      FoodItem(id: 'f041', name: 'Almonds', caloriesPer100g: 579, proteinPer100g: 21, carbsPer100g: 22, fatsPer100g: 50, category: 'Snacks'),
      FoodItem(id: 'f042', name: 'Peanut Butter', caloriesPer100g: 588, proteinPer100g: 25, carbsPer100g: 20, fatsPer100g: 50, category: 'Snacks'),
      FoodItem(id: 'f043', name: 'Dark Chocolate (70%)', caloriesPer100g: 598, proteinPer100g: 7.8, carbsPer100g: 46, fatsPer100g: 43, category: 'Snacks'),
      FoodItem(id: 'f044', name: 'Walnuts', caloriesPer100g: 654, proteinPer100g: 15, carbsPer100g: 14, fatsPer100g: 65, category: 'Snacks'),
      FoodItem(id: 'f045', name: 'Protein Bar', caloriesPer100g: 350, proteinPer100g: 20, carbsPer100g: 40, fatsPer100g: 12, category: 'Snacks'),
      FoodItem(id: 'f046', name: 'Granola', caloriesPer100g: 471, proteinPer100g: 10, carbsPer100g: 64, fatsPer100g: 20, category: 'Snacks'),

      // === BEVERAGES ===
      FoodItem(id: 'f047', name: 'Black Coffee', caloriesPer100g: 2, proteinPer100g: 0.3, carbsPer100g: 0, fatsPer100g: 0, category: 'Beverages'),
      FoodItem(id: 'f048', name: 'Green Tea', caloriesPer100g: 1, proteinPer100g: 0, carbsPer100g: 0.2, fatsPer100g: 0, category: 'Beverages'),
      FoodItem(id: 'f049', name: 'Orange Juice', caloriesPer100g: 45, proteinPer100g: 0.7, carbsPer100g: 10, fatsPer100g: 0.2, category: 'Beverages'),
      FoodItem(id: 'f050', name: 'Smoothie (mixed fruit)', caloriesPer100g: 54, proteinPer100g: 0.8, carbsPer100g: 13, fatsPer100g: 0.2, category: 'Beverages'),
    ];
  }

  static List<String> get categories => [
    'Grains',
    'Protein',
    'Dairy',
    'Fruits',
    'Vegetables',
    'Snacks',
    'Beverages',
  ];

  static List<FoodItem> getFoodsByCategory(String category) {
    return getAllFoods().where((f) => f.category == category).toList();
  }

  static FoodItem? getFoodById(String id) {
    try {
      return getAllFoods().firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<FoodItem> searchFoods(String query) {
    final lower = query.toLowerCase();
    return getAllFoods()
        .where((f) =>
            f.name.toLowerCase().contains(lower) ||
            f.category.toLowerCase().contains(lower))
        .toList();
  }
}
