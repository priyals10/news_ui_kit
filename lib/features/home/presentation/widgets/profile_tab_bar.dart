import 'package:flutter/material.dart';

/// A horizontal tab bar used on the profile screen for "News" / "Recent" tabs.
///
/// Uses an underline border indicator for the active tab.
class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onTabSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      }),
    );
  }
}
