import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/dark_mode_tile.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SettingsTile(
            icon: Icons.notifications_none_outlined,
            label: 'Notification',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            label: 'Security',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.help_outline,
            label: 'Help',
            onTap: () {},
          ),
          const DarkModeTile(),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isSuccess) {
                // Clear user data on logout
                context.read<BookmarkBloc>().add(ClearBookmarks());
                
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.onboarding,
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              return SettingsTile(
                icon: state.isLoading ? Icons.hourglass_empty : Icons.logout_outlined,
                label: state.isLoading ? 'Logging out...' : 'Logout',
                showArrow: false,
                onTap: state.isLoading 
                  ? () {} 
                  : () => context.read<AuthBloc>().add(LogoutRequested()),
              );
            },
          ),
        ],
      ),
    );
  }
}
