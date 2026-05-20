import 'package:flutter/material.dart';

/// A reusable settings list tile with icon, label, and optional chevron arrow.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.showArrow = true,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showArrow;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = labelColor ?? colorScheme.onSurface;
    final activeIconColor = iconColor ?? colorScheme.onSurface;
    final arrowColor = colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: activeIconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(Icons.chevron_right, size: 22, color: arrowColor),
          ],
        ),
      ),
    );
  }
}
