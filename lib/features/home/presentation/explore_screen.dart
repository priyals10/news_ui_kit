import 'package:flutter/material.dart';
// import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Explore', style: AppTextStyles.headingSmall(context)),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Explore — coming soon', style: TextStyle(color: colorScheme.onSurface)),
      ),
    );
  }
}
