enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snacks';
    }
  }

  String get icon {
    switch (this) {
      case MealType.breakfast:
        return '🌅';
      case MealType.lunch:
        return '☀️';
      case MealType.dinner:
        return '🌙';
      case MealType.snack:
        return '🍿';
    }
  }
}

class MealEntry {
  final String id;
  final String foodItemId;
  final String foodName;
  final MealType mealType;
  final double quantity; // in grams
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final DateTime date;
  final bool isSynced;

  MealEntry({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.mealType,
    required this.quantity,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.date,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodItemId': foodItemId,
      'foodName': foodName,
      'mealType': mealType.index,
      'quantity': quantity,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
      'date': date.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory MealEntry.fromMap(Map<dynamic, dynamic> map) {
    return MealEntry(
      id: map['id'] ?? '',
      foodItemId: map['foodItemId'] ?? '',
      foodName: map['foodName'] ?? '',
      mealType: MealType.values[map['mealType'] ?? 0],
      quantity: (map['quantity'] ?? 0).toDouble(),
      totalCalories: (map['totalCalories'] ?? 0).toDouble(),
      totalProtein: (map['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (map['totalCarbs'] ?? 0).toDouble(),
      totalFats: (map['totalFats'] ?? 0).toDouble(),
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      isSynced: map['isSynced'] ?? false,
    );
  }

  MealEntry copyWith({bool? isSynced}) {
    return MealEntry(
      id: id,
      foodItemId: foodItemId,
      foodName: foodName,
      mealType: mealType,
      quantity: quantity,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFats: totalFats,
      date: date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
