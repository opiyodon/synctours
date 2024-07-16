import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:synctours/screens/user/weather_forecast.dart';
import 'package:synctours/screens/user/locate_in_map.dart';
import 'package:synctours/screens/user/calculate_distance.dart';
import 'package:synctours/screens/user/video_search.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/services/database.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/models/favorite_place.dart';

class PlaceDetails extends StatefulWidget {
  final Map<String, dynamic> place;

  const PlaceDetails({super.key, required this.place});

  @override
  PlaceDetailsState createState() => PlaceDetailsState();
}

class PlaceDetailsState extends State<PlaceDetails> {
  late Stream<DocumentSnapshot> _favoriteStream;
  late FavoritePlace _favoritePlace;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<CustomUser?>(context, listen: false);
    _favoritePlace = FavoritePlace(
      id: widget.place['id'] ??
          FirebaseFirestore.instance.collection('favorite_places').doc().id,
      name: widget.place['name'] ?? '',
      formatted: widget.place['formatted'] ?? '',
      image: widget.place['images']?.isNotEmpty == true
          ? widget.place['images'][0]
          : '',
      isFavorite: false,
      uid: user?.uid ?? '',
    );

    if (user != null && user.uid != null) {
      _favoriteStream = FirebaseFirestore.instance
          .collection('favorite_places')
          .doc(_favoritePlace.id)
          .snapshots();
      _favoriteStream.listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>?;
          setState(() {
            _isFavorite = data?['isFavorite'] ?? false;
          });
        }
      });
    }
  }

  void _toggleFavorite(bool isFavorite) async {
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user != null && user.uid != null) {
      try {
        _favoritePlace = _favoritePlace.copyWith(isFavorite: isFavorite);
        await DatabaseService(uid: user.uid!)
            .toggleFavoritePlace(_favoritePlace);
        setState(() {
          _isFavorite = isFavorite;
        });
      } catch (e) {
        print("Error toggling favorite place: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorite: $e')),
        );
      }
    } else {
      print("User is not logged in");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.place['name'] ?? 'Place Details',
          style: const TextStyle(color: AppColors.buttonText),
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColors.buttonText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 7),
              ),
              items: [
                (widget.place['images'] as List<dynamic>? ?? []).firstOrNull
              ].whereType<String>().map<Widget>((image) {
                return Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Image not available'));
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.place['description'] ??
                              'No description available',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FavoriteButton(
                        isFavorite: _isFavorite,
                        valueChanged: _toggleFavorite,
                        iconSize: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Location: ${widget.place['formatted'] ?? 'N/A'}'),
                  Text('Country: ${widget.place['country'] ?? 'N/A'}'),
                  Text('State: ${widget.place['state'] ?? 'N/A'}'),
                  Text('City: ${widget.place['city'] ?? 'N/A'}'),
                  Text('Postcode: ${widget.place['postcode'] ?? 'N/A'}'),
                  const SizedBox(height: 30),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.0,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocateInMap(
                                  location: widget.place['formatted'] ?? ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map,
                                color: AppColors.buttonText, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'View on Map',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.buttonText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherForecast(
                                  location: widget.place['formatted'] ?? ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud,
                                color: AppColors.buttonText, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Weather Forecast',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.buttonText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoSearch(
                                  location: widget.place['formatted'] ?? ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library,
                                color: AppColors.buttonText, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Watch Videos',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.buttonText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalculateDistance(
                                  location: widget.place['formatted'] ?? ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate,
                                color: AppColors.buttonText, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Calculate Distance',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.buttonText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
