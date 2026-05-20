import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';

/// A utility class that centralises all [SharedPreferences] access.
///
/// Rationale: if SharedPreferences is ever replaced by another storage
/// solution (e.g. flutter_secure_storage, Hive) the change only needs to
/// happen here, not scattered across the codebase.
class PreferencesHelper {
  PreferencesHelper._();

  // ── Has Seen Onboarding ──────────────────────────────────────────────────

  static Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppPrefsKeys.hasSeenOnboarding) ?? false;
  }

  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefsKeys.hasSeenOnboarding, value);
  }

  // ── Remember Me ──────────────────────────────────────────────────────────

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppPrefsKeys.rememberMe) ?? true;
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefsKeys.rememberMe, value);
  }

  // ── Setup Completion ─────────────────────────────────────────────────────

  static Future<bool> getHasCompletedSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_completed_setup') ?? false;
  }

  static Future<void> setHasCompletedSetup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_setup', value);
  }
}
