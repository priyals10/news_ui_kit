import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/constants/app_strings.dart';
import 'package:news_ui_kit/core/router/app_router.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';
import 'package:news_ui_kit/core/widgets/app_ui_kit.dart';
import 'package:news_ui_kit/core/widgets/web_constrained_layout.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WebConstrainedLayout(
        maxWidth: 800,
        scrollable: false, // Page has its own ListView
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingXL),
            Text(AppStrings.selectYourCountry, style: AppTextStyles.headingSmall(context)),
            const SizedBox(height: AppSizes.spacingXL),
            
            AppTextField(
              label: AppStrings.search,
              controller: searchController,
              isRequired: false,
              hintText: 'Search for your country',
            ),
  
            const SizedBox(height: AppSizes.spacingS),
  
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];
                  final isSelected = selectedCountry?.countryCode == country.countryCode;
  
                  return GestureDetector(
                    onTap: () => setState(() => selectedCountry = country),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: "https://flagcdn.com/w40/${country.countryCode.toLowerCase()}.png",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Text(country.flagEmoji),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              country.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
  
            const SizedBox(height: 16),
            AppPrimaryButton(
              text: AppStrings.next,
              onPressed: selectedCountry == null ? null : () {
                Navigator.pushNamed(context, AppRouter.chooseTopics, arguments: selectedCountry!);
              },
            ),
            const SizedBox(height: AppSizes.spacingXL),
          ],
        ),
      ),
    );
  }
}
