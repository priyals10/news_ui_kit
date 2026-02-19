import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:news_ui_kit/features/home/news_sources/choose_news_sources_screen.dart';

class ChooseTopicsScreen extends StatefulWidget {
  final picker.Country selectedCountry;

  const ChooseTopicsScreen({
    super.key,
    required this.selectedCountry,
  });

  @override
  State<ChooseTopicsScreen> createState() =>
      _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState
    extends State<ChooseTopicsScreen> {
  final TextEditingController searchController =
      TextEditingController();

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
          .where((topic) =>
              topic.toLowerCase().contains(query))
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

              /// Top Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Choose your Topics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
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

              const SizedBox(height: 20),

              /// Topics Section
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          filteredTopics.map((topic) {
                        final isSelected =
                            selectedTopics
                                .contains(topic);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTopics
                                    .remove(topic);
                              } else {
                                selectedTopics
                                    .add(topic);
                              }
                            });
                          },
                          child: Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 28,
                              vertical: 15,
                            ),
                            decoration:
                                BoxDecoration(
                              color: isSelected
                                  ? const Color(
                                      0xFF1877F2)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          6),
                              border: Border.all(
                                color:
                                    const Color(
                                        0xFF1877F2),
                              ),
                            ),
                            child: Text(
                              topic,
                              style:
                                  TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color: isSelected
                                    ? Colors
                                        .white
                                    : const Color(
                                        0xFF1877F2),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              /// Next Button with Navigation
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      selectedTopics.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChooseNewsSourceScreen(),
                                ),
                              );
                            },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTopics.isEmpty
                            ? Colors.grey.shade300
                            : const Color(
                                0xFF1877F2),
                    foregroundColor:
                        selectedTopics.isEmpty
                            ? Colors.grey.shade600
                            : Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                            vertical: 18),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
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
