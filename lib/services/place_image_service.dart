import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctours/utils/image_utils.dart';

class PlaceImageService {
  static final String mapboxApiKey = dotenv.env['MAPBOX_API_KEY']!;
  static const String mapboxApiUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';
  static final String unsplashApiKey = dotenv.env['UNSPLASH_API_KEY']!;
  static const String unsplashApiUrl = 'https://api.unsplash.com/search/photos';

  static DateTime _lastRequestTime = DateTime.now();
  static const int _maxRequestsPerDay = 5000;
  static const String _lastRequestDateKey = 'lastRequestDate';
  static const String _requestCountKey = 'requestCount';

  static Future<void> _enforceRateLimit() async {
    final now = DateTime.now();
    final timeSinceLastRequest = now.difference(_lastRequestTime);
    if (timeSinceLastRequest < const Duration(seconds: 1)) {
      await Future.delayed(const Duration(seconds: 1) - timeSinceLastRequest);
    }
    _lastRequestTime = DateTime.now();
  }

  static Future<bool> _canMakeRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestDate = prefs.getString(_lastRequestDateKey);
    final requestCount = prefs.getInt(_requestCountKey) ?? 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastRequestDate != today.toIso8601String()) {
      await prefs.setString(_lastRequestDateKey, today.toIso8601String());
      await prefs.setInt(_requestCountKey, 1);
      return true;
    }

    if (requestCount < _maxRequestsPerDay) {
      await prefs.setInt(_requestCountKey, requestCount + 1);
      return true;
    }

    return false;
  }

  static Future<Map<String, dynamic>> fetchPlaceDetails(String query) async {
    if (await _canMakeRequest()) {
      await _enforceRateLimit();

      final response = await http.get(
        Uri.parse(
            '$mapboxApiUrl/$query.json?access_token=$mapboxApiKey&country=KE'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['features'];
        if (data.isNotEmpty) {
          final place = data[0]['place_name'];
          final coordinates = data[0]['center'];
          return {
            'name': place,
            'lat': coordinates[1],
            'lon': coordinates[0],
            'formatted': place,
            'categories':
                [], // Mapbox doesn't provide categories in geocoding API
          };
        } else {
          throw Exception('No results found for the query');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } else {
      // Calculate when the user can try again
      final prefs = await SharedPreferences.getInstance();
      final lastRequestDate = prefs.getString(_lastRequestDateKey);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (lastRequestDate != today.toIso8601String()) {
        await prefs.setString(_lastRequestDateKey, today.toIso8601String());
        await prefs.setInt(_requestCountKey, 1);
        final retryTime = now.add(const Duration(days: 1)).difference(now);
        throw Exception(
            'Daily request limit exceeded. Please try again in ${retryTime.inHours} hours.');
      } else {
        final requestCount = prefs.getInt(_requestCountKey) ?? 0;
        final retryTime = now.add(const Duration(days: 1)).difference(now);
        final remainingRequests = _maxRequestsPerDay - requestCount;
        throw Exception(
            'Daily request limit exceeded. Please try again in ${retryTime.inHours} hours. Remaining requests for today: $remainingRequests');
      }
    }
  }

  static Future<String> fetchImageUrl(String query) async {
    final response = await http.get(
        Uri.parse('$unsplashApiUrl?query=$query&client_id=$unsplashApiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'][0]['urls']['regular'];
    } else {
      throw Exception('Failed to load image');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllPlaces() async {
    List<String> places = getDestinationNames();
    List<Map<String, dynamic>> placeDetailsList = [];

    for (String place in places) {
      try {
        final details = await fetchPlaceDetails(place);
        final imageUrl = await fetchImageUrl(place);
        placeDetailsList.add({
          ...details,
          'imageUrl': imageUrl,
        });
      } catch (e) {
        print("Error fetching place: $place, $e");
      }
    }

    return placeDetailsList;
  }

  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final details = await fetchPlaceDetails(query);
      final imageUrl = await fetchImageUrl(query);
      return [
        {
          ...details,
          'imageUrl': imageUrl,
        }
      ];
    } catch (e) {
      print("Error searching places: $e");
      return [];
    }
  }
}
