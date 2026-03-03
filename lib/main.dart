import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/app.dart';
import 'package:news_ui_kit/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  SystemChrome.setSystemUIOverlayStyle(AppTheme.defaultSystemUI);
  runApp(const App());
}
