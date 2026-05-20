import 'package:flutter/material.dart';

class NavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  static const List<NavDestination> items = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    NavDestination(
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
    ),
    // Middle item is usually for spacing in centered docked FAB, but for rail/drawer we'll handle it separately
    NavDestination(
      label: 'Bookmark',
      icon: Icons.bookmark_outline,
      selectedIcon: Icons.bookmark,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];
}
