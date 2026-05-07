import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/sync_service.dart';
import 'meal_planning_screen.dart';
import 'daily_tracking_screen.dart';
import 'analytics_screen.dart';
import 'search_filter_screen.dart';
import 'goal_setting_screen.dart';

/// Home screen with bottom navigation bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _syncService = SyncService();

  final List<Widget> _screens = const [
    MealPlanningScreen(),
    DailyTrackingScreen(),
    AnalyticsScreen(),
    SearchFilterScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _syncService.startListening();
  }

  @override
  void dispose() {
    _syncService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.restaurant_menu_rounded, 'Plan'),
                _buildNavItem(1, Icons.track_changes_rounded, 'Track'),
                _buildNavItem(2, Icons.analytics_rounded, 'Analytics'),
                _buildNavItem(3, Icons.search_rounded, 'Search'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGreen.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
