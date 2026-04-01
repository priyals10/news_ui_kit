import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/search_bloc.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/search_event.dart';
import 'package:news_ui_kit/features/home/presentation/bloc/search_state.dart';
import 'package:news_ui_kit/features/home/presentation/widgets/latest_article_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _controller.text.trim();
    context.read<SearchBloc>().add(SearchNews(query));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () {
            context.read<SearchBloc>().add(ClearSearch());
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 48,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _onSearch(),
            onChanged: (value) {
              setState(() {});
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                _onSearch();
              });
            },
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            decoration: InputDecoration(
              isDense: true,
              hintText: AppStrings.search,
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
              prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 24),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant, size: 20),
                      onPressed: () {
                        _controller.clear();
                        _onSearch(); 
                        setState(() {});
                      },
                    ),
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        titleSpacing: 8,
        actions: [
          TextButton(
            onPressed: _onSearch,
            child: Text(
              AppStrings.search,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(state.message, textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          } else if (state is SearchLoaded) {
            if (state.results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off, size: 64, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(
                      'No results found for "${state.query}"',
                      style: AppTextStyles.greyText(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.spacingL,
              ),
              itemCount: state.results.length,
              separatorBuilder: (_, __) => Divider(
                color: colorScheme.outline.withValues(alpha: 0.6),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final article = state.results[index];
                return LatestArticleTile(
                  article: article,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.articleDetail,
                      arguments: article,
                    );
                  },
                );
              },
            );
          }
          // Initial state — show hint
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 64, color: colorScheme.outline),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  'Search for news articles',
                  style: AppTextStyles.greyText(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
