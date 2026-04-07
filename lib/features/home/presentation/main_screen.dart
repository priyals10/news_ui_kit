import 'package:flutter/material.dart';
import 'package:news_ui_kit/features/home/presentation/home_screen.dart';
import 'package:news_ui_kit/features/home/presentation/explore_screen.dart';
import 'package:news_ui_kit/features/home/presentation/bookmark_screen.dart';
import 'package:news_ui_kit/features/home/presentation/profile_screen.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/core/utils/responsive.dart';
import 'package:news_ui_kit/features/home/presentation/models/nav_destination.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Key _profileKey = UniqueKey();
  
  // Cache the screens to prevent re-initialization on every build/tab-switch.
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Fetch bookmarks for the currently logged in user
    context.read<BookmarkBloc>().add(LoadBookmarks());
    _buildScreens();
  }

  void _buildScreens() {
    _screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const BookmarkScreen(),
      ProfileScreen(key: _profileKey),
    ];
  }

  // Helper to get index for Rail (removes the dummy index 2 from logic)
  int _getRailIndex() {
    if (_currentIndex > 2) return _currentIndex - 1;
    return _currentIndex;
  }

  void _handleRailTap(int index) {
      setState(() {
        if (index >= 2) {
           _currentIndex = index + 1;
        } else {
           _currentIndex = index;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;
    
    // Ensure index is valid after a breakpoint change (e.g. rotation)
    // Mobile has 5 items (including FAB space), Desktop has 4.
    if (!isMobile && _currentIndex > 3) {
      _currentIndex = 3; 
    }
    
    // Screens for display (using IndexedStack)
    // For mobile, index 2 is FAB space.
    // For Desktop/Tablet, we use a clean 4-screen list.
    final displayScreens = [
      _screens[0],
      _screens[1],
      if (isMobile) const SizedBox.shrink(), // Space for FAB
      _screens[2],
      _screens[3],
    ];

    Widget? fab = FloatingActionButton(
      onPressed: () => _openCreateNews(context),
      backgroundColor: colorScheme.primary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );

    if (isMobile) {
      return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: displayScreens,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: fab,
        bottomNavigationBar: _buildBottomNavBar(colorScheme),
      );
    }

    // Tablet/Desktop Layout: Row with NavigationRail + Content
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(colorScheme),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _getRailIndex(),
              children: _screens,
            ),
          ),
        ],
      ),
      floatingActionButton: context.isTablet ? fab : null, // Show FAB only if not expanded drawer
    );
  }

  void _openCreateNews(BuildContext context) async {
    final result = await Navigator.pushNamed(context, AppRouter.createNews);
    if (result == true) {
      setState(() {
        _profileKey = UniqueKey();
        _currentIndex = context.isMobile ? 4 : 3; // Profile Tab
        _buildScreens();
      });
    }
  }

  // Removed redundant isMobile getter to use context.isMobile instead

  Widget _buildBottomNavBar(ColorScheme colorScheme) {
     return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) return;
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      );
  }

  Widget _buildNavigationRail(ColorScheme colorScheme) {
    return NavigationRail(
      selectedIndex: _getRailIndex(),
      onDestinationSelected: _handleRailTap,
      labelType: context.isDesktop ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      extended: context.isDesktop,
      backgroundColor: colorScheme.surface,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurface.withValues(alpha: 0.6)),
      leading: context.isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: () => _openCreateNews(context),
          label: const Text('Create News'),
          icon: const Icon(Icons.add),
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ) : null,
      destinations: NavDestination.items.map((dest) {
        return NavigationRailDestination(
          icon: Icon(dest.icon),
          selectedIcon: Icon(dest.selectedIcon),
          label: Text(dest.label),
        );
      }).toList(),
    );
  }
}
