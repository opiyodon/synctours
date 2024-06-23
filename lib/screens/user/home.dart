import 'package:flutter/material.dart';
import 'package:synctours/screens/user/search_results.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/destination_card.dart';
import 'package:synctours/widgets/trending_card.dart';
import 'package:synctours/widgets/recent_search_item.dart';
import 'package:synctours/widgets/section_title.dart';
import 'package:synctours/services/place_image_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> featuredDestinations = [];
  List<Map<String, dynamic>> trendingPlaces = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      List<Map<String, dynamic>> places =
          await PlaceImageService.fetchAllPlaces();
      setState(() {
        featuredDestinations = places.take(4).toList();
        trendingPlaces = places.skip(4).take(6).toList();
      });
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  void _searchPlaces() {
    String query = _searchController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResults(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Container(
        color: Colors.grey[100],
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
                      subtitle: 'Explore the beauty of Kenya',
                      imageUrl: place['imageUrl'] ?? '',
                      placeDetails: place,
                    );
                  },
                  childCount: featuredDestinations.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
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
                        imageUrl: place['imageUrl'] ?? '',
                        placeDetails: place,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SectionTitle(title: 'Recent Searches'),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    RecentSearchItem(query: 'Nairobi'),
                    RecentSearchItem(query: 'Mombasa'),
                    RecentSearchItem(query: 'Maasai Mara'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
