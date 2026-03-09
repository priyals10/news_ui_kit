import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_button.dart';
import 'package:news_ui_kit/core/widgets/app_search_field.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController searchController = TextEditingController();

  picker.Country? selectedCountry;
  late List<picker.Country> countries;
  late List<picker.Country> filteredCountries;

  @override
  void initState() {
    super.initState();
    countries = picker.CountryService().getAll();
    filteredCountries = countries;
    searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCountries = countries
          .where((country) => country.name.toLowerCase().contains(query))
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

              Text(AppStrings.selectYourCountry, style: AppTextStyles.headingSmall(context)),

              const SizedBox(height: AppSizes.spacingXL),

              AppSearchField(controller: searchController),

              const SizedBox(height: AppSizes.spacingS),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final isSelected =
                        selectedCountry?.countryCode == country.countryCode;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: AppSizes.spacingXS),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.inputPaddingH,
                          vertical: AppSizes.inputPaddingH,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.transparent,
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://flagcdn.com/w40/${country.countryCode.toLowerCase()}.png",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Text(country.flagEmoji, style: const TextStyle(fontSize: 18)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                country.name,
                                style: isSelected
                                  ? AppTextStyles.listItemSelected(context)
                                  : AppTextStyles.listItem(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              AppButton(
                text: AppStrings.next,
                isEnabled: selectedCountry != null,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.chooseTopics,
                    arguments: selectedCountry!,
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
