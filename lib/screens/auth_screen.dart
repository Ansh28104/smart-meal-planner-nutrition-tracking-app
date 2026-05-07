import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final provider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool success;
    if (_isLogin) {
      success = await provider.signIn(email, password);
    } else {
      success = await provider.signUp(email, password);
    }

    if (!success && mounted && provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.2),
              ),
            ).animate().scale(duration: 1.seconds, curve: Curves.easeOutCubic),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppTheme.cardDark : AppTheme.primaryDark).withValues(alpha: 0.1),
              ),
            ).animate().scale(delay: 200.ms, duration: 1.seconds, curve: Curves.easeOutCubic),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 80,
                        color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2),
                      const SizedBox(height: 24),
                      Text(
                        'Smart Meal Planner',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                            ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin ? 'Welcome back!' : 'Create your account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 48),

                      // Input Fields
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                        validator: (v) => v!.isEmpty || !v.contains('@') ? 'Enter a valid email' : null,
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_rounded,
                        isPassword: true,
                        isDark: isDark,
                        validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null,
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                      const SizedBox(height: 32),

                      // Submit Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? AppTheme.primaryGreen : AppTheme.primaryDark).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: FilledButton(
                          onPressed: authProvider.isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                            foregroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  _isLogin ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).scale(curve: Curves.easeOutBack),
                      
                      const SizedBox(height: 24),
                      
                      // Toggle
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          });
                        },
                        child: Text(
                          _isLogin ? "Don't have an account? Sign Up" : 'Already have an account? Sign In',
                          style: TextStyle(
                            color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : AppTheme.textPrimaryLight),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.textSecondary),
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        filled: true,
        fillColor: isDark ? AppTheme.cardDark : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppTheme.primaryGreen : AppTheme.primaryDark,
            width: 2,
          ),
        ),
      ),
    );
  }
}
