import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/auth/data/auth_repository.dart';
import 'package:news_ui_kit/core/theme/theme_mode_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textBlack;
    final iconColor = isDark ? Colors.white : AppColors.textBlack;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTile(
            context: context,
            icon: Icons.notifications_none_outlined,
            label: 'Notification',
            onTap: () {},
          ),
          _buildTile(
            context: context,
            icon: Icons.lock_outline,
            label: 'Security',
            onTap: () {},
          ),
          _buildTile(
            context: context,
            icon: Icons.help_outline,
            label: 'Help',
            onTap: () {},
          ),
          _buildDarkModeTile(),
          _buildTile(
            context: context,
            icon: Icons.logout_outlined,
            label: 'Logout',
            showArrow: false,
            onTap: () async {
              await AuthRepository().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.onboarding,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textBlack;
    final iconColor = isDark ? Colors.white : AppColors.textBlack;
    final arrowColor = isDark ? Colors.white70 : AppColors.greyDark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(Icons.chevron_right, size: 22, color: arrowColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;
        final textColor = isDark ? Colors.white : AppColors.textBlack;
        final iconColor = isDark ? Colors.white : AppColors.textBlack;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            children: [
              Icon(Icons.dark_mode_outlined, size: 22, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                child: Switch(
                  value: isDark,
                  onChanged: (val) {
                    themeModeNotifier.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
