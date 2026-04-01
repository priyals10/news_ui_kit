import 'package:flutter/material.dart';
import 'package:news_ui_kit/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:news_ui_kit/features/home/data/models/local_news.dart';
import 'package:news_ui_kit/features/home/data/models/local_headline.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open(
    [LocalNewsSchema, LocalHeadlineSchema],
    directory: dir.path,
  );

  runApp(const App());
}
