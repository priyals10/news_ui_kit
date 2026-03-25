import 'package:flutter/material.dart';

/// A reusable settings list tile with icon, label, and optional chevron arrow.
///
/// Extracted from `SettingsScreen._buildTile()` to keep build methods lean
/// and enable independent reuse across other settings flows.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.showArrow = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onSurface;
    final iconColor = colorScheme.onSurface;
    final arrowColor = colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
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
