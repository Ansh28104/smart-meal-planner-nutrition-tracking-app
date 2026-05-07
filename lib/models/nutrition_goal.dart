class NutritionGoal {
  final double targetCalories;
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFats;

  NutritionGoal({
    required this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFats,
  });

  Map<String, dynamic> toMap() {
    return {
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
    };
  }

  factory NutritionGoal.fromMap(Map<dynamic, dynamic> map) {
    return NutritionGoal(
      targetCalories: (map['targetCalories'] ?? 2000).toDouble(),
      targetProtein: map['targetProtein'] != null
          ? (map['targetProtein']).toDouble()
          : null,
      targetCarbs: map['targetCarbs'] != null
          ? (map['targetCarbs']).toDouble()
          : null,
      targetFats: map['targetFats'] != null
          ? (map['targetFats']).toDouble()
          : null,
    );
  }

  factory NutritionGoal.defaultGoal() {
    return NutritionGoal(
      targetCalories: 2000,
      targetProtein: 50,
      targetCarbs: 250,
      targetFats: 65,
    );
  }
}
