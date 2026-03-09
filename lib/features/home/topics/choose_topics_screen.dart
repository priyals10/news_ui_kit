import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_button.dart';
import 'package:news_ui_kit/core/widgets/app_search_field.dart';

class ChooseTopicsScreen extends StatefulWidget {
  final picker.Country selectedCountry;

  const ChooseTopicsScreen({super.key, required this.selectedCountry});

  @override
  State<ChooseTopicsScreen> createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> topics = [
    "National",
    "International",
    "Sport",
    "Lifestyle",
    "Business",
    "Health",
    "Fashion",
    "Technology",
    "Science",
    "Art",
    "Politics",
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
      filteredTopics = topics
          .where((topic) => topic.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingHSmall),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingXL),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(AppStrings.chooseYourTopics, style: AppTextStyles.headingSmall(context)),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: AppSizes.spacingXL),

              AppSearchField(controller: searchController),

              const SizedBox(height: AppSizes.spacingXL),

              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: AppSizes.spacingS,
                      runSpacing: AppSizes.spacingS,
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.white,
                              borderRadius: BorderRadius.circular(AppSizes.radiusS),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              topic,
                                style: isSelected
                                  ? AppTextStyles.chipTextSelected(context)
                                  : AppTextStyles.chipText(context),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              AppButton(
                text: AppStrings.next,
                isEnabled: selectedTopics.isNotEmpty,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.chooseNewsSources,
                    arguments: widget.selectedCountry.name,
                  );
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
