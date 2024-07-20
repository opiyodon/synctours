import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctours/utils/image_utils.dart';

class PlaceImageService {
  static final String geopifyApiKey = dotenv.env['GEOAPIFY_API_KEY']!;
  static const String geopifyApiUrl =
      'https://api.geoapify.com/v1/geocode/search';
  static final String mapboxApiKey = dotenv.env['MAPBOX_API_KEY']!;
  static const String mapboxApiUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';
  static final String unsplashApiKey = dotenv.env['UNSPLASH_API_KEY']!;
  static const String unsplashApiUrl = 'https://api.unsplash.com/search/photos';

  static DateTime _lastRequestTime = DateTime.now();
  static const int _maxRequestsPerDay = 3000;
  static const String _lastRequestDateKey = 'lastRequestDate';
  static const String _requestCountKey = 'requestCount';
  static const String _cacheKey = 'placeCache';
  static const Duration _cacheExpiration = Duration(days: 1);

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

  static String generatePlaceId(Map<String, dynamic> place) {
    String uniqueString = '${place['name']}${place['formatted']}${place['country']}';
    var bytes = utf8.encode(uniqueString);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  static Future<Map<String, dynamic>> fetchPlaceDetails(
      String query, String userId) async {
    if (await _canMakeRequest()) {
      await _enforceRateLimit();

      final geoapifyResponse = await http.get(
        Uri.parse(
            '$geopifyApiUrl?text=$query&apiKey=$geopifyApiKey&country=KE'),
      );

      final mapboxResponse = await http.get(
        Uri.parse(
            '$mapboxApiUrl/$query.json?access_token=$mapboxApiKey&country=KE'),
      );

      final unsplashResponse = await http.get(
        Uri.parse(
            '$unsplashApiUrl?query=$query&client_id=$unsplashApiKey&per_page=5'),
      );

      if (geoapifyResponse.statusCode == 200 &&
          mapboxResponse.statusCode == 200 &&
          unsplashResponse.statusCode == 200) {
        final geoapifyData = json.decode(geoapifyResponse.body)['features'];
        final mapboxData = json.decode(mapboxResponse.body)['features'];
        final unsplashData = json.decode(unsplashResponse.body)['results'];

        if (geoapifyData.isNotEmpty && mapboxData.isNotEmpty) {
          final geoapifyPlace = geoapifyData[0]['properties'];
          final mapboxPlace = mapboxData[0];

          final placeDetails = {
            'name':
                geoapifyPlace['name'] ?? mapboxPlace['place_name'] ?? 'Unknown',
            'lat': geoapifyPlace['lat'] ?? mapboxPlace['center'][1],
            'lon': geoapifyPlace['lon'] ?? mapboxPlace['center'][0],
            'formatted':
                geoapifyPlace['formatted'] ?? mapboxPlace['place_name'],
            'categories': geoapifyPlace['categories'] ??
                mapboxPlace['context'].map((item) => item['id']).toList(),
            'country': geoapifyPlace['country'] ?? 'Kenya',
            'state': geoapifyPlace['state'] ?? '',
            'city': geoapifyPlace['city'] ?? '',
            'postcode': geoapifyPlace['postcode'] ?? '',
            'description': mapboxPlace['text'] ?? '',
            'images':
                unsplashData.map((image) => image['urls']['regular']).toList(),
          };

          placeDetails['id'] = generatePlaceId(placeDetails);

          return placeDetails;
        } else {
          throw Exception('No results found for the query');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } else {
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

  static Future<List<Map<String, dynamic>>> fetchAllPlaces(
      String userId) async {
    List<String> allPlaces = getDestinationNames();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> cache =
        json.decode(prefs.getString(_cacheKey) ?? '{}');

    List<Future<Map<String, dynamic>>> futures = [];

    for (String place in allPlaces) {
      if (cache.containsKey(place) &&
          DateTime.now().difference(DateTime.parse(cache[place]['timestamp'])) <
              _cacheExpiration) {
        futures.add(Future.value(cache[place]['data']));
      } else {
        futures.add(fetchPlaceDetails(place, userId).then((details) {
          cache[place] = {
            'data': details,
            'timestamp': DateTime.now().toIso8601String(),
          };
          prefs.setString(_cacheKey, json.encode(cache));
          return details;
        }).catchError((e) {
          print("Error fetching place: $place, $e");
          return <String, dynamic>{};
        }));
      }
    }

    List<Map<String, dynamic>> placeDetailsList = await Future.wait(futures);
    return placeDetailsList.where((place) => place.isNotEmpty).toList();
  }

  static Future<List<Map<String, dynamic>>> searchPlaces(
      String query, String userId) async {
    try {
      final details = await fetchPlaceDetails(query, userId);
      return [details];
    } catch (e) {
      print("Error searching places: $e");
      return [];
    }
  }
}
