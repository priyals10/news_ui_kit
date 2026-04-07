import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global theme mode notifier for app-wide theme switching, with persistence.
class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  static const _key = 'theme_mode';
  bool _isInitialized = false;

  ThemeModeNotifier() : super(ThemeMode.light);

  bool get isInitialized => _isInitialized;

  /// Call this at app startup to ensure theme is loaded.
  Future<void> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mode = prefs.getString(_key);
      if (mode == 'dark') {
        value = ThemeMode.dark;
      } else {
        value = ThemeMode.light;
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      _isInitialized = true;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    // Ensure it's persisted on Web immediately
    if (WebPrefUtils.isWeb) {
       // On Web, LocalStorage is sync, but we already awaited getString. 
       // No extra step needed, but calling commit() or similar if it existed would be here.
    }
  }
}

class WebPrefUtils {
  static bool get isWeb => identical(0, 0.0); // Simple web check
}

final themeModeNotifier = ThemeModeNotifier();
