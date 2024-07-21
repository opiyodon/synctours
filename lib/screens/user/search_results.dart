import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/destination_card.dart';
import 'package:synctours/services/place_image_service.dart';
import 'package:synctours/widgets/loading.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({super.key, required this.query});

  @override
  SearchResultsState createState() => SearchResultsState();
}

class SearchResultsState extends State<SearchResults> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchPlaces(widget.query);
  }

  Future<void> searchPlaces(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = Provider.of<CustomUser?>(context, listen: false);
      if (user != null && user.uid != null) {
        List<Map<String, dynamic>> places =
            await PlaceImageService.searchPlaces(query, user.uid!);
        setState(() {
          searchResults = places;
          isLoading = false;
        });
      } else {
        // Handle the case when the user is not logged in
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error searching places: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Search Results',
          style: TextStyle(color: AppColors.buttonText),
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColors.buttonText,
        ),
      ),
      body: isLoading
          ? const Loading()
          : RefreshIndicator(
              onRefresh: () => searchPlaces(widget.query),
              child: searchResults.isEmpty
                  ? ListView(
                      children: const [
                        Center(child: Text('No results found')),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final place = searchResults[index];
                        return DestinationCard(
                          title: place['name'] ?? 'Unknown',
                          subtitle: place['formatted'] ??
                              'Explore the beauty of Kenya',
                          imageUrl: place['images']?.isNotEmpty == true
                              ? place['images'][0]
                              : '',
                          placeDetails: place,
                          placeId: PlaceImageService.generatePlaceId(place),
                        );
                      },
                    ),
            ),
    );
  }
}
