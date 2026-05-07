class FoodItem {
  final String id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final String category;
  final bool isCustom;

  FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    required this.category,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'caloriesPer100g': caloriesPer100g,
      'proteinPer100g': proteinPer100g,
      'carbsPer100g': carbsPer100g,
      'fatsPer100g': fatsPer100g,
      'category': category,
      'isCustom': isCustom,
    };
  }

  factory FoodItem.fromMap(Map<dynamic, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      caloriesPer100g: (map['caloriesPer100g'] ?? 0).toDouble(),
      proteinPer100g: (map['proteinPer100g'] ?? 0).toDouble(),
      carbsPer100g: (map['carbsPer100g'] ?? 0).toDouble(),
      fatsPer100g: (map['fatsPer100g'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      isCustom: map['isCustom'] ?? false,
    );
  }

  /// Calculate nutrition for a given quantity in grams
  double caloriesForQuantity(double grams) => (caloriesPer100g / 100) * grams;
  double proteinForQuantity(double grams) => (proteinPer100g / 100) * grams;
  double carbsForQuantity(double grams) => (carbsPer100g / 100) * grams;
  double fatsForQuantity(double grams) => (fatsPer100g / 100) * grams;
}
