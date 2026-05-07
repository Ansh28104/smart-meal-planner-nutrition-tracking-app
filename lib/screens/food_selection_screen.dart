import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../models/meal_entry.dart';
import '../providers/meal_provider.dart';
import '../data/hive_service.dart';
import '../data/food_database.dart';
import '../theme/app_theme.dart';
import '../widgets/food_tile.dart';

/// Screen 2: Food Selection / Entry - search and add food items
class FoodSelectionScreen extends StatefulWidget {
  final MealType mealType;
  const FoodSelectionScreen({super.key, required this.mealType});

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  late List<FoodItem> _allFoods;

  @override
  void initState() {
    super.initState();
    _allFoods = HiveService.getAllFoodItems();
  }

  List<FoodItem> get _filteredFoods {
    var foods = _allFoods;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      foods = foods.where((f) =>
          f.name.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q)).toList();
    }
    if (_selectedCategory != null) {
      foods = foods.where((f) => f.category == _selectedCategory).toList();
    }
    return foods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to ${widget.mealType.displayName}'),
        actions: [
          TextButton.icon(
            onPressed: _showAddCustomFoodDialog,
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text('Custom'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search food items...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),
          // Category chips
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildChip('All', null),
                ...FoodDatabase.categories.map((c) => _buildChip(c, c)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Food list
          Expanded(
            child: _filteredFoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No foods found', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: _filteredFoods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      return FoodTile(
                        food: food,
                        onTap: () => _showQuantityDialog(food),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = isSelected ? null : category),
        selectedColor: AppTheme.primaryGreen.withOpacity(0.15),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  void _showQuantityDialog(FoodItem food) {
    final controller = TextEditingController(text: '100');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(food.name),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Quantity (grams)',
                  suffixText: 'g',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter quantity';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Must be > 0';
                  if (n > 5000) return 'Max 5000g';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Preview nutrition
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (_, __, ___) {
                  final qty = double.tryParse(controller.text) ?? 0;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _previewItem('Calories', '${food.caloriesForQuantity(qty).toInt()}', 'kcal', AppTheme.calorieColor),
                        _previewItem('Protein', '${food.proteinForQuantity(qty).toInt()}', 'g', AppTheme.proteinColor),
                        _previewItem('Carbs', '${food.carbsForQuantity(qty).toInt()}', 'g', AppTheme.carbsColor),
                        _previewItem('Fats', '${food.fatsForQuantity(qty).toInt()}', 'g', AppTheme.fatsColor),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final qty = double.parse(controller.text);
                context.read<MealProvider>().addMeal(
                  food: food,
                  mealType: widget.mealType,
                  quantity: qty,
                );
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${food.name} added to ${widget.mealType.displayName}'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _previewItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16)),
        Text('$label', style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
      ],
    );
  }

  void _showAddCustomFoodDialog() {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final protCtrl = TextEditingController(text: '0');
    final carbCtrl = TextEditingController(text: '0');
    final fatCtrl = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Custom Food'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Food Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: calCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Calories per 100g'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Must be > 0';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: protCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Protein (g)'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextFormField(controller: carbCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Carbs (g)'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextFormField(controller: fatCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fats (g)'))),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final food = FoodItem(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  caloriesPer100g: double.parse(calCtrl.text),
                  proteinPer100g: double.tryParse(protCtrl.text) ?? 0,
                  carbsPer100g: double.tryParse(carbCtrl.text) ?? 0,
                  fatsPer100g: double.tryParse(fatCtrl.text) ?? 0,
                  category: 'Custom',
                  isCustom: true,
                );
                await HiveService.addCustomFood(food);
                setState(() => _allFoods = HiveService.getAllFoodItems());
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
