import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_ui_kit/features/home/topics/choose_topics_screen.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() =>
      _SelectCountryScreenState();
}

class _SelectCountryScreenState
    extends State<SelectCountryScreen> {
  final TextEditingController searchController =
      TextEditingController();

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
          .where((country) =>
              country.name.toLowerCase().contains(query))
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Title
              const Text(
                "Select your Country",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 20),

              /// Search Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.grey.shade400),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16),
                    suffixIcon: Padding(
                      padding:
                          const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        "assets/icons/search.svg",
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Country List
              Expanded(
                child: ListView.builder(
                  itemCount:
                      filteredCountries.length,
                  itemBuilder:
                      (context, index) {
                    final country =
                        filteredCountries[index];

                    final isSelected =
                        selectedCountry
                                ?.countryCode ==
                            country.countryCode;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCountry =
                              country;
                        });
                      },
                      child: Container(
                        margin:
                            const EdgeInsets
                                .symmetric(
                                    vertical: 6),
                        padding:
                            const EdgeInsets
                                .symmetric(
                                    horizontal: 14,
                                    vertical: 14),
                        decoration:
                            BoxDecoration(
                          color: isSelected
                              ? const Color(
                                  0xFF1877F2)
                              : Colors
                                  .transparent,
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 28,
                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            6),
                              ),
                              clipBehavior:
                                  Clip.hardEdge,
                              child:
                                  CachedNetworkImage(
                                imageUrl:
                                    "https://flagcdn.com/w40/${country.countryCode.toLowerCase()}.png",
                                fit: BoxFit.cover,
                                placeholder:
                                    (context,
                                            url) =>
                                        const Center(
                                  child:
                                      SizedBox(
                                    width: 16,
                                    height: 16,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                    ),
                                  ),
                                ),
                                errorWidget:
                                    (context,
                                            url,
                                            error) =>
                                        Center(
                                  child: Text(
                                    country
                                        .flagEmoji,
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          18,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                country.name,
                                style:
                                    TextStyle(
                                  fontSize:
                                      16,
                                  fontWeight:
                                      FontWeight
                                          .w500,
                                  color: isSelected
                                      ? Colors
                                          .white
                                      : Colors
                                          .black87,
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

              /// Next Button with Navigation
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      selectedCountry == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseTopicsScreen(
                                    selectedCountry:
                                        selectedCountry!,
                                  ),
                                ),
                              );
                            },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedCountry == null
                            ? Colors
                                .grey
                                .shade300
                            : const Color(
                                0xFF1877F2),
                    foregroundColor:
                        selectedCountry == null
                            ? Colors
                                .grey
                                .shade600
                            : Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets
                            .symmetric(
                                vertical: 18),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  10),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
