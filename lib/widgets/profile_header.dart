import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Avatar + who's signed in + an "Account" / "Guest mode" tag.
class ProfileHeader extends StatelessWidget {
  final String? email;
  final bool isGuest;
  const ProfileHeader({super.key, required this.email, required this.isGuest});

  static const double _avatarRadius = 28;

  @override
  Widget build(BuildContext context) {
    final title = isGuest ? 'Hello, guest' : email ?? 'No email on file';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                isGuest ? Icons.person_outline : Icons.person,
                color: AppColors.primaryDark,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headingMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildTag(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isGuest ? AppColors.accent : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isGuest ? 'Guest mode' : 'Account',
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
