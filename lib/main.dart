import 'package:flutter/material.dart';
import 'package:news_ui_kit/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:news_ui_kit/features/home/data/models/local_news.dart';
import 'package:news_ui_kit/features/home/data/models/local_headline.dart';
import 'package:flutter/foundation.dart';
import 'package:news_ui_kit/core/theme/theme_mode_notifier.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Isar? isar;
  try {
    if (kIsWeb) {
      isar = Isar.getInstance('news_db_v1');
      isar ??= await Isar.open(
        [LocalNewsSchema, LocalHeadlineSchema],
        directory: '',
        name: 'news_db_v1',
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      isar = Isar.getInstance('news_db_v1');
      isar ??= await Isar.open(
        [LocalNewsSchema, LocalHeadlineSchema],
        directory: dir.path,
        name: 'news_db_v1',
      );
    }
  } catch (e) {
    debugPrint('Isar initialization failed: $e. Attempting safe recovery...');
  }
  // Pre-load persistent state
  await themeModeNotifier.loadThemeMode();

  runApp(App(isar: isar));
}
