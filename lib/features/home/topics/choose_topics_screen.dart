import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class ChooseTopicsScreen extends StatefulWidget {
  final picker.Country selectedCountry;

  const ChooseTopicsScreen({super.key, required this.selectedCountry});

  @override
  State<ChooseTopicsScreen> createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> topics = [
    "National", "International", "Sport", "Lifestyle", "Business",
    "Health", "Fashion", "Technology", "Science", "Art", "Politics",
  ];

  List<String> filteredTopics = [];
  Set<String> selectedTopics = {};

  @override
  void initState() {
    super.initState();
    filteredTopics = topics;
    searchController.addListener(_filterTopics);
  }

  void _filterTopics() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTopics = topics.where((topic) => topic.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.chooseYourTopics, style: AppTextStyles.headingSmall(context)),
      ),
      body: SafeArea(
        child: WebConstrainedLayout(
          maxWidth: 800,
          scrollable: false,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingXL),
              AppTextField(
                label: AppStrings.search,
                controller: searchController,
                isRequired: false,
                hintText: 'Search for topics',
              ),
              const SizedBox(height: AppSizes.spacingXL),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filteredTopics.map((topic) {
                      final isSelected = selectedTopics.contains(topic);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedTopics.remove(topic);
                            } else {
                              selectedTopics.add(topic);
                            }
                          });
                        },
                        child: Chip(
                          label: Text(topic),
                          backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.outline),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                text: AppStrings.next,
                onPressed: selectedTopics.isEmpty ? null : () {
                  Navigator.pushNamed(context, AppRouter.chooseNewsSources, arguments: widget.selectedCountry.name);
                },
              ),
              const SizedBox(height: AppSizes.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
