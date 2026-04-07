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
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

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
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 20),
                onPressed: () {
                  context.read<SearchBloc>().add(ClearSearch());
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
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
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 16),
                      prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 22),
                      suffixIcon: _controller.text.isEmpty
                          ? null
                          : IconButton(
                              icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant, size: 18),
                              onPressed: () {
                                _controller.clear();
                                _onSearch(); 
                                setState(() {});
                              },
                            ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
        ),
      ),
      body: WebConstrainedLayout(
        maxWidth: 900,
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator()));
            } else if (state is SearchError) {
              return Center(child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(state.message, style: TextStyle(color: colorScheme.onSurface)),
              ));
            } else if (state is SearchLoaded) {
              if (state.results.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text('No results found for "${state.query}"', style: TextStyle(color: colorScheme.onSurface)),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSizes.screenPaddingH),
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final article = state.results[index];
                  return LatestArticleTile(
                    article: article,
                    onTap: () => Navigator.pushNamed(context, AppRouter.articleDetail, arguments: article),
                  );
                },
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Icon(Icons.search, size: 64, color: colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('Search for news articles', style: AppTextStyles.greyText(context)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
