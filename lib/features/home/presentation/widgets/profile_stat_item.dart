import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';

/// Displays a single stat (value + label) on the profile header.
class ProfileStatItem extends StatelessWidget {
  const ProfileStatItem({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headingSmall(context)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall(context)
              .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
