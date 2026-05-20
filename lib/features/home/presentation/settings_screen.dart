import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_event.dart';
import 'package:news_ui_kit/features/auth/presentation/bloc/auth_state.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/bookmark_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/dark_mode_tile.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/settings_tile.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text('Settings', style: AppTextStyles.headingSmall(context)),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebConstrainedLayout(
        scrollable: false,
        maxWidth: 700,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingL),
          children: [
            // ── Account Section ──
            _buildSectionHeader(context, 'Personal'),
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
            
            const SizedBox(height: 24),
            
            // ── App Section ──
            _buildSectionHeader(context, 'App Settings'),
            SettingsTile(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () {},
            ),
            const DarkModeTile(),

            const SizedBox(height: 24),
            
            // ── Logout Section ──
            _buildSectionHeader(context, 'Action'),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.isSuccess) {
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
      labelColor: Colors.redAccent,
      iconColor: Colors.redAccent,
      showArrow: false,
      onTap: state.isLoading 
        ? () {} 
        : () => context.read<AuthBloc>().add(LogoutRequested()),
    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
