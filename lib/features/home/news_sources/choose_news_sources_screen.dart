import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_ui_kit/features/home/fill_profile/fill_profile_screen.dart';

class NewsSource {
  final String name;
  final String logo;
  bool isFollowing;

  NewsSource({
    required this.name,
    required this.logo,
    this.isFollowing = false,
  });
}

class ChooseNewsSourceScreen extends StatefulWidget {
  const ChooseNewsSourceScreen({super.key});

  @override
  State<ChooseNewsSourceScreen> createState() =>
      _ChooseNewsSourceScreenState();
}

class _ChooseNewsSourceScreenState extends State<ChooseNewsSourceScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<NewsSource> sources = [
    NewsSource(name: "CNBC", logo: "assets/logos/cnbc.png"),
    NewsSource(name: "VICE", logo: "assets/logos/vice.png"),
    NewsSource(name: "Vox", logo: "assets/logos/vox.png"),
    NewsSource(name: "BBC News", logo: "assets/logos/bbc.png"),
    NewsSource(name: "SCMP", logo: "assets/logos/scmp.png"),
    NewsSource(name: "CNN", logo: "assets/logos/cnn.png"),
    NewsSource(name: "MSN", logo: "assets/logos/msn.png"),
    NewsSource(name: "CNET", logo: "assets/logos/cnet.png"),
    NewsSource(name: "USA Today", logo: "assets/logos/usa_today.png"),
  ];

  List<NewsSource> filteredSources = [];

  @override
  void initState() {
    super.initState();
    filteredSources = sources;
    searchController.addListener(_filterSources);
  }

  void _filterSources() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredSources = sources
          .where((source) => source.name.toLowerCase().contains(query))
          .toList();
    });
  }

  bool get hasSelection => sources.any((s) => s.isFollowing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        "Choose your News Sources",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: 20),

              /// Search
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1877F2)),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SvgPicture.asset(
                        "assets/icons/search.svg",
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredSources.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 210,
                  ),
                  itemBuilder: (context, index) {
                    final source = filteredSources[index];

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF1F4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.asset(
                                      source.logo,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                source.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    source.isFollowing = !source.isFollowing;
                                  });
                                },
                                child: Container(
                                  width: 95,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: source.isFollowing
                                        ? const Color(0xFF1877F2)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFF1877F2)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      source.isFollowing
                                          ? "Following"
                                          : "Follow",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: source.isFollowing
                                            ? Colors.white
                                            : const Color(0xFF1877F2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasSelection
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FillProfileScreen(),
                        ),
                      );
                    }
                  : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasSelection
                        ? const Color(0xFF1877F2)
                        : Colors.grey.shade300,
                    foregroundColor:
                        hasSelection ? Colors.white : Colors.grey.shade600,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
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
