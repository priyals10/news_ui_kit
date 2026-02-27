import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/app.dart';
import 'package:news_ui_kit/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.defaultSystemUI);
  runApp(const App());
}
