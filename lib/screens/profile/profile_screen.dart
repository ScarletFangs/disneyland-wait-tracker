import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/utils/auth_validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authServiceObject = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userAnonymous = authServiceObject.isCurrentUserAnonymous;

    if (userAnonymous == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: SafeArea(
          child: Column(
            children: [
              Text(
                "Something went wrong loading user information",
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
      );
    }

    if (userAnonymous) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: SafeArea(child: _buildAnonymousView()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SafeArea(child: _buildSignedInView()),
    );
  }

  Widget _buildAnonymousView() {
    return Form(
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
          if (_errorText == null)
            Text("Login to save your preferences across devices!"),
          ElevatedButton(
            onPressed: _isLoading ? null : _linkAccount,
            child: Text("Sign Up"),
          ),
          ElevatedButton(
            onPressed: authServiceObject.logout,
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Widget _buildSignedInView() {
    return SafeArea(
      child: Column(
        children: [
          Text(authServiceObject.currentUserEmail ?? "Email not Found"),
          ElevatedButton(
            onPressed: authServiceObject.logout,
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Future<void> _linkAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;
    final errorText = await authServiceObject.linkGuestToAccount(
      enteredEmail,
      enteredPassword,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorText = errorText;
    });
  }
}
