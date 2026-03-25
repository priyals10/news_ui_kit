import 'package:flutter/material.dart';
import 'package:news_ui_kit/features/home/presentation/home_screen.dart';
import 'package:news_ui_kit/features/home/presentation/explore_screen.dart';
import 'package:news_ui_kit/features/home/presentation/bookmark_screen.dart';
import 'package:news_ui_kit/features/home/presentation/profile_screen.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';

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
      const SizedBox.shrink(), // Dummy screen for the middle FAB spacer
      const BookmarkScreen(),
      ProfileScreen(key: _profileKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRouter.createNews);
          if (result == true) {
            // Force ProfileScreen to re-initialize its state to fetch new news
            // and automatically switch to Profile Tab (index 4)
            setState(() {
              _profileKey = UniqueKey();
              _currentIndex = 4;
              _buildScreens(); // Rebuild screens with the new key
            });
          }
        },
        backgroundColor: colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) return; // Ignore tapping the dummy FAB spacer
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // Dummy icon for spacing
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
