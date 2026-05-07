import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/food_search_provider.dart';
import 'data/hive_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()..loadMeals()),
        ChangeNotifierProvider(create: (_) => GoalProvider()..loadGoals()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => FoodSearchProvider()),
      ],
      child: const SmartMealPlannerApp(),
    ),
  );
}
