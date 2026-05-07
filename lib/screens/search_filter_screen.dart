import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/food_search_provider.dart';
import '../models/meal_entry.dart';
import '../theme/app_theme.dart';

/// Screen 5: Search & Filter - search meal history by food name, date, meal type
class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FoodSearchProvider>(
          builder: (context, searchProvider, _) {
            final results = searchProvider.filteredMealEntries;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search History', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: searchProvider.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search logged meals...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchProvider.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => searchProvider.setSearchQuery(''),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Date Filter
                            ActionChip(
                              label: Text(
                                searchProvider.filterStartDate != null
                                    ? '${DateFormat('MMM d').format(searchProvider.filterStartDate!)} - ${searchProvider.filterEndDate != null ? DateFormat('MMM d').format(searchProvider.filterEndDate!) : ''}'
                                    : 'Any Date',
                              ),
                              avatar: const Icon(Icons.calendar_today, size: 16),
                              onPressed: () async {
                                final range = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                  initialDateRange: searchProvider.filterStartDate != null && searchProvider.filterEndDate != null
                                      ? DateTimeRange(start: searchProvider.filterStartDate!, end: searchProvider.filterEndDate!)
                                      : null,
                                );
                                if (range != null) {
                                  searchProvider.setDateRange(range.start, range.end);
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            // Meal Type Filter
                            ActionChip(
                              label: Text(searchProvider.filterMealType?.displayName ?? 'All Meals'),
                              avatar: const Icon(Icons.restaurant, size: 16),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        title: const Text('All Meals'),
                                        onTap: () {
                                          searchProvider.setMealTypeFilter(null);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ...MealType.values.map(
                                        (type) => ListTile(
                                          title: Text(type.displayName),
                                          leading: Text(type.icon),
                                          onTap: () {
                                            searchProvider.setMealTypeFilter(type);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            if (searchProvider.filterStartDate != null || searchProvider.filterMealType != null)
                              ActionChip(
                                label: const Text('Clear Filters'),
                                avatar: const Icon(Icons.clear, size: 16),
                                backgroundColor: AppTheme.danger.withOpacity(0.1),
                                onPressed: searchProvider.clearFilters,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text('No entries found', style: TextStyle(color: Colors.grey.shade500)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final entry = results[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('MMM dd, yyyy').format(entry.date),
                                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      if (!entry.isSynced)
                                        Icon(Icons.cloud_upload_outlined, size: 16, color: AppTheme.warning),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(entry.mealType.icon, style: const TextStyle(fontSize: 24)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(entry.foodName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                            Text('${entry.quantity.toInt()}g', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${entry.totalCalories.toInt()} kcal',
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
