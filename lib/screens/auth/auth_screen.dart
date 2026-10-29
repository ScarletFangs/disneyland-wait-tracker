import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/utils/auth_validators.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  String? _errorText;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  static const String _appName = 'Wait Tracker';
  static const String _tagline = 'Every Disneyland wait, one screen.';
  static const double _logoSize = 88;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBrand(),
                const SizedBox(height: 32),
                _buildFormCard(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : _guestLogin,
                  child: const Text("Continue as Guest"),
                ),
                Text(
                  "No account needed — you can upgrade later.",
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          width: _logoSize,
          height: _logoSize,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.castle,
            size: 48,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        Text(_appName, style: AppTextStyles.displayLarge),
        const SizedBox(height: 6),
        Text(
          _tagline,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    final errorText = _errorText;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                validator: validatePassword,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.errorDark,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _userLogin,
                child: const Text("Log In"),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _isLoading ? null : _signUp,
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guestLogin() async {
    setState(() => _isLoading = true);
    final errorText = await _authService.guestLogin();
    if (!mounted) return;
    setState(() {
      _errorText = errorText;
      _isLoading = false;
    });
  }

  Future<void> _userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final errorText = await _authService.userLogin(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() {
      _errorText = errorText;
      _isLoading = false;
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final errorText = await _authService.createAccount(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() {
      _errorText = errorText;
      _isLoading = false;
    });
  }
}
