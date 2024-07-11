import 'package:flutter/material.dart';
import 'package:synctours/screens/user/search_results.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/destination_card.dart';
import 'package:synctours/widgets/trending_card.dart';
import 'package:synctours/widgets/recent_search_item.dart';
import 'package:synctours/widgets/section_title.dart';
import 'package:synctours/services/place_image_service.dart';
import 'package:synctours/widgets/loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allPlaces = [];
  List<Map<String, dynamic>> featuredDestinations = [];
  List<Map<String, dynamic>> trendingPlaces = [];
  List<String> recentSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      allPlaces = await PlaceImageService.fetchAllPlaces();
      setState(() {
        featuredDestinations = allPlaces.take(4).toList();
        trendingPlaces = allPlaces.skip(4).take(6).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching places: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchPlaces() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches = recentSearches.sublist(0, 5);
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResults(query: query),
        ),
      );
    }
  }

  void _clearRecentSearches() {
    setState(() {
      recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sync Tours'),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Loading()
          : RefreshIndicator(
        onRefresh: _fetchPlaces,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appBackground,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Where to in Kenya?',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) => _searchPlaces(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SectionTitle(title: 'Featured Destinations in Kenya'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final place = featuredDestinations[index];
                      return DestinationCard(
                        title: place['name'] ?? 'Unknown',
                        subtitle: place['formatted'] ?? 'Explore the beauty of Kenya',
                        imageUrl: place['images']?.isNotEmpty == true ? place['images'][0] : '',
                        placeDetails: place,
                      );
                    },
                    childCount: featuredDestinations.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SectionTitle(title: 'Trending in Kenya'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingPlaces.length,
                    itemBuilder: (context, index) {
                      final place = trendingPlaces[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TrendingCard(
                          title: place['name'] ?? 'Unknown',
                          imageUrl: place['images']?.isNotEmpty == true ? place['images'][0] : '',
                          placeDetails: place,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SectionTitle(title: 'Recent Searches'),
                          if (recentSearches.isNotEmpty)
                            TextButton(
                              onPressed: _clearRecentSearches,
                              child: const Text('Clear'),
                            ),
                        ],
                      ),
                      if (recentSearches.isNotEmpty)
                        Column(
                          children: recentSearches
                              .map((query) => RecentSearchItem(query: query))
                              .toList(),
                        )
                      else
                        const Text('No recent searches',
                            style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}