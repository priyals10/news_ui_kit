import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar styling (backgroundColor, elevation, centerTitle) comes from
    // AppTheme.appBarTheme — no need to repeat it on every screen.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore', style: AppTextStyles.headingSmall(context)),
        centerTitle: false,
      ),
      body: WebConstrainedLayout(
        scrollable: false,
        child: Center(
          child: Text(
            'Explore — coming soon',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
