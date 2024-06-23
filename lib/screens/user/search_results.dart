import 'package:flutter/material.dart';
import 'package:synctours/widgets/destination_card.dart';
import 'package:synctours/services/place_image_service.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({super.key, required this.query});

  @override
  SearchResultsState createState() => SearchResultsState();
}

class SearchResultsState extends State<SearchResults> {
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchPlaces(widget.query);
  }

  Future<void> _searchPlaces(String query) async {
    try {
      List<Map<String, dynamic>> places =
          await PlaceImageService.searchPlaces(query);
      setState(() {
        searchResults = places;
      });
    } catch (e) {
      print("Error searching places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final place = searchResults[index];
                return DestinationCard(
                  title: place['name'] ?? 'Unknown',
                  subtitle: 'Explore the beauty of Kenya',
                  imageUrl: place['imageUrl'] ?? '',
                  placeDetails: place,
                );
              },
            ),
    );
  }
}
