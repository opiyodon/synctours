import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:synctours/screens/user/weather_forecast.dart';
import 'package:synctours/screens/user/locate_in_map.dart';
import 'package:synctours/screens/user/calculate_distance.dart';
import 'package:synctours/screens/user/video_search.dart';
import 'package:synctours/theme/colors.dart';

class PlaceDetails extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlaceDetails({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          place['name'],
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
              items: (place['images'] as List<dynamic>).map<Widget>((image) {
                return Image.network(
                  image,
                  fit: BoxFit.cover,
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
                          place['description'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FavoriteButton(
                        isFavorite: false,
                        valueChanged: (isFavorite) {
                          // Handle favorite state change
                        },
                        iconSize: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Location: ${place['formatted']}'),
                  Text('Country: ${place['country']}'),
                  Text('State: ${place['state']}'),
                  Text('City: ${place['city']}'),
                  Text('Postcode: ${place['postcode']}'),
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
                              builder: (context) =>
                                  LocateInMap(location: place['formatted']),
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
                              builder: (context) =>
                                  WeatherForecast(location: place['formatted']),
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
                              builder: (context) =>
                                  VideoSearch(location: place['formatted']),
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
                                  location: place['formatted']),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
