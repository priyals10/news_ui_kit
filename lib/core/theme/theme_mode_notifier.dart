import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global theme mode notifier for app-wide theme switching, with persistence.
class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
	static const _key = 'theme_mode';
	ThemeModeNotifier() : super(ThemeMode.light) {
		_loadThemeMode();
	}

	Future<void> _loadThemeMode() async {
		final prefs = await SharedPreferences.getInstance();
		final mode = prefs.getString(_key);
		if (mode == 'dark') {
			value = ThemeMode.dark;
		} else {
			value = ThemeMode.light;
		}
	}

	Future<void> setThemeMode(ThemeMode mode) async {
		value = mode;
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
	}
}

final themeModeNotifier = ThemeModeNotifier();
