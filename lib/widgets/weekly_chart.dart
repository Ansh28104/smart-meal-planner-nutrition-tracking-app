import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_log.dart';
import '../theme/app_theme.dart';

/// Weekly bar chart showing daily calorie intake vs goal
class WeeklyChart extends StatelessWidget {
  final List<DailyLog> data;
  final double targetCalories;

  const WeeklyChart({
    super.key,
    required this.data,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = _getMaxY();

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppTheme.textPrimary,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final log = data[group.x.toInt()];
                return BarTooltipItem(
                  '${DateFormat('EEE').format(log.date)}\n${rod.toY.toInt()} kcal',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        DateFormat('E').format(data[index].date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: targetCalories > 0 ? targetCalories : 500,
            getDrawingHorizontalLine: (value) {
              if (value == targetCalories) {
                return FlLine(
                  color: AppTheme.secondaryOrange.withOpacity(0.5),
                  strokeWidth: 2,
                  dashArray: [8, 4],
                );
              }
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 0.5,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final log = entry.value;
      final isOverGoal = log.totalCalories > targetCalories && targetCalories > 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: log.totalCalories,
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isOverGoal
                  ? [AppTheme.danger.withOpacity(0.7), AppTheme.danger]
                  : log.totalCalories > 0
                      ? [
                          AppTheme.primaryGreen.withOpacity(0.6),
                          AppTheme.primaryGreen,
                        ]
                      : [Colors.grey.shade300, Colors.grey.shade300],
            ),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY() {
    double max = targetCalories;
    for (final log in data) {
      if (log.totalCalories > max) max = log.totalCalories;
    }
    return (max * 1.2).ceilToDouble();
  }
}
