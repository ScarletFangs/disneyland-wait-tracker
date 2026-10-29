import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/widgets/profile_header.dart';
import 'package:disneyapp/widgets/status_message.dart';
import 'package:flutter/material.dart';
import 'package:disneyapp/services/auth_service.dart';
import 'package:disneyapp/utils/auth_validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final isAnonymous = _authService.isCurrentUserAnonymous;

    if (isAnonymous == null) {
      return const StatusMessage(
        icon: Icons.error_outline,
        message: "Couldn't load your profile",
        hint: 'Try closing and reopening the app.',
        isError: true,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileHeader(
          email: _authService.currentUserEmail,
          isGuest: isAnonymous,
        ),
        if (isAnonymous) ...[const SizedBox(height: 16), _buildUpgradeCard()],
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _authService.logout,
          icon: const Icon(Icons.logout),
          label: const Text("Log Out"),
        ),
        if (isAnonymous) ...[
          const SizedBox(height: 8),
          Text(
            "Guest favorites are lost when you log out.",
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildUpgradeCard() {
    final errorText = _errorText;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Upgrade your account", style: AppTextStyles.headingMedium),
              const SizedBox(height: 6),
              Text(
                "Create an account to keep your favorites across devices. "
                "Everything you saved as a guest comes with you.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _linkAccount,
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _linkAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;
    final errorText = await _authService.linkGuestToAccount(
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
