import 'package:flutter/material.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchPlaces(widget.query);
  }

  Future<void> _searchPlaces(String query) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Map<String, dynamic>> places =
      await PlaceImageService.searchPlaces(query);
      setState(() {
        searchResults = places;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error searching places: $e");
      setState(() {
        _isLoading = false;
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
      body: _isLoading
          ? const Loading()
          : RefreshIndicator(
        onRefresh: () => _searchPlaces(widget.query),
        child: searchResults.isEmpty
            ? ListView(
          children: const [
            Center(child: Text('No results found')),
          ],
        )
            : GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              subtitle: place['formatted'] ?? 'Explore the beauty of Kenya',
              imageUrl: place['images']?[0] ?? '',
              placeDetails: place,
            );
          },
        ),
      ),
    );
  }
}