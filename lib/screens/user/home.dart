import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:synctours/services/database.dart';
import 'package:synctours/models/recent_search.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      final user = Provider.of<CustomUser?>(context, listen: false);
      if (user != null && user.uid != null) {
        allPlaces = await PlaceImageService.fetchAllPlaces(user.uid!);
        setState(() {
          featuredDestinations = allPlaces.take(4).toList();
          trendingPlaces = allPlaces.skip(4).take(10).toList();
          _isLoading = false;
        });
      } else {
        // Handle the case when the user is not logged in
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchPlaces(BuildContext context) async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final user = Provider.of<CustomUser?>(context, listen: false);
      if (user != null) {
        try {
          await DatabaseService(uid: user.uid!).saveRecentSearch(query);
        } catch (e) {
          debugPrint('Error saving recent search: $e');
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResults(query: query),
        ),
      );
    }
  }

  void _clearRecentSearches(BuildContext context) async {
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user != null) {
      try {
        await DatabaseService(uid: user.uid!).clearRecentSearches();
      } catch (e) {
        debugPrint('Error clearing recent searches: $e');
      }
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?', textAlign: TextAlign.center),
            content: const Text('Do you want to exit the app?',
                textAlign: TextAlign.center),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            actions: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.buttonText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('No', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.buttonText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Yes', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final result = await _onWillPop();
        if (result) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Sync Tours',
          actions: [],
        ),
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
                            onSubmitted: (_) => _searchPlaces(context),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SectionTitle(
                              title: 'Featured Destinations in Kenya'),
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
                                subtitle: place['formatted'] ??
                                    'Explore the beauty of Kenya',
                                imageUrl: place['images']?.isNotEmpty == true
                                    ? place['images'][0]
                                    : '',
                                placeDetails: place,
                                placeId:
                                    PlaceImageService.generatePlaceId(place),
                              );
                            },
                            childCount: featuredDestinations.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trendingPlaces.length,
                            itemBuilder: (context, index) {
                              final place = trendingPlaces[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TrendingCard(
                                  title: place['name'] ?? 'Unknown',
                                  imageUrl: place['images']?.isNotEmpty == true
                                      ? place['images'][0]
                                      : '',
                                  placeDetails: place,
                                  placeId:
                                      PlaceImageService.generatePlaceId(place),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SectionTitle(title: 'Recent Searches'),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _clearRecentSearches(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.buttonText,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28, vertical: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Clear',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              if (user != null)
                                StreamBuilder<List<RecentSearch>>(
                                  stream: DatabaseService(uid: user.uid!)
                                      .recentSearches,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.accent),
                                      );
                                    } else if (snapshot.hasError) {
                                      debugPrint(
                                          'Error fetching recent searches: ${snapshot.error}');
                                      return const Text(
                                          'Error loading recent searches',
                                          style: TextStyle(color: Colors.red));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text('No recent searches',
                                          style: TextStyle(color: Colors.grey));
                                    } else {
                                      final recentSearches = snapshot.data!;
                                      return Column(
                                        children: recentSearches
                                            .map((search) => RecentSearchItem(
                                                query: search.query))
                                            .toList(),
                                      );
                                    }
                                  },
                                )
                              else
                                const Text(
                                    'Please log in to see recent searches',
                                    style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
