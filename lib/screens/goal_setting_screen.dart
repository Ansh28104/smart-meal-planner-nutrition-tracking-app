import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goal_provider.dart';
import '../models/nutrition_goal.dart';
import '../theme/app_theme.dart';

/// Screen 6: Goal Setting - configure target calories and macros
class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _calCtrl;
  late TextEditingController _protCtrl;
  late TextEditingController _carbCtrl;
  late TextEditingController _fatCtrl;

  @override
  void initState() {
    super.initState();
    final currentGoal = context.read<GoalProvider>().goal;
    _calCtrl = TextEditingController(text: currentGoal.targetCalories.toInt().toString());
    _protCtrl = TextEditingController(text: currentGoal.targetProtein?.toInt().toString() ?? '');
    _carbCtrl = TextEditingController(text: currentGoal.targetCarbs?.toInt().toString() ?? '');
    _fatCtrl = TextEditingController(text: currentGoal.targetFats?.toInt().toString() ?? '');
  }

  @override
  void dispose() {
    _calCtrl.dispose();
    _protCtrl.dispose();
    _carbCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Goals'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Daily Targets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInputRow('Calories', _calCtrl, AppTheme.calorieColor, true),
            const SizedBox(height: 16),
            const Text('Macronutrients (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInputRow('Protein (g)', _protCtrl, AppTheme.proteinColor, false),
            const SizedBox(height: 12),
            _buildInputRow('Carbs (g)', _carbCtrl, AppTheme.carbsColor, false),
            const SizedBox(height: 12),
            _buildInputRow('Fats (g)', _fatCtrl, AppTheme.fatsColor, false),
            const SizedBox(height: 40),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newGoal = NutritionGoal(
                    targetCalories: double.parse(_calCtrl.text),
                    targetProtein: double.tryParse(_protCtrl.text),
                    targetCarbs: double.tryParse(_carbCtrl.text),
                    targetFats: double.tryParse(_fatCtrl.text),
                  );
                  context.read<GoalProvider>().saveGoal(newGoal);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Goals updated successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller, Color color, bool isRequired) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (v) {
              if (isRequired && (v == null || v.isEmpty)) return 'Required';
              if (v != null && v.isNotEmpty) {
                final n = double.tryParse(v);
                if (n == null || n < 0) return 'Invalid';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
