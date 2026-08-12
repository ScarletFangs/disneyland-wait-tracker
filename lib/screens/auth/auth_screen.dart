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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: _passwordController,
                validator: validatePassword,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              if (_errorText != null)
                Text(_errorText!, style: TextStyle(color: AppColors.error)),
              ElevatedButton(
                onPressed: _isLoading ? null : _userLogin,
                child: Text("Login"),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: Text("Sign Up"),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _guestLogin,
                child: Text("Continue as Guest"),
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
