import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/sync_service.dart';
import 'meal_planning_screen.dart';
import 'daily_tracking_screen.dart';
import 'analytics_screen.dart';
import 'search_filter_screen.dart';

/// Home screen with a floating glassmorphic bottom navigation bar
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Allows content to flow behind the floating nav bar
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark)
                    .withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.restaurant_menu_rounded, 'Plan', isDark),
                    _buildNavItem(1, Icons.track_changes_rounded, 'Track', isDark),
                    _buildNavItem(2, Icons.analytics_rounded, 'Stats', isDark),
                    _buildNavItem(3, Icons.search_rounded, 'Search', isDark),
                  ],
                ),
              ),
            ),
          ),
        ).animate().slideY(begin: 1, curve: Curves.easeOutExpo, duration: 800.ms),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    final primaryColor = isDark ? AppTheme.primaryGreen : AppTheme.primaryDark;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : AppTheme.textSecondary,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ).animate().fadeIn().slideX(begin: 0.2),
            ],
          ],
        ),
      ),
    );
  }
}
