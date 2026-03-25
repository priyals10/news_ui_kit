import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/theme/theme_mode_notifier.dart';

/// A settings tile with a toggle switch to switch between light/dark theme.
///
/// Extracted from `SettingsScreen._buildDarkModeTile()` into its own
/// StatelessWidget to keep the parent build method clean.
class DarkModeTile extends StatelessWidget {
  const DarkModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;
        final colorScheme = Theme.of(context).colorScheme;
        final textColor = colorScheme.onSurface;
        final iconColor = colorScheme.onSurface;

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
                    themeModeNotifier.setThemeMode(
                      val ? ThemeMode.dark : ThemeMode.light,
                    );
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
