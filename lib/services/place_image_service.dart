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
  static final String pexelsApiKey = dotenv.env['PEXELS_API_KEY']!;
  static const String pexelsApiUrl = 'https://api.pexels.com/v1/search';
  static final String unsplashApiKey = dotenv.env['UNSPLASH_API_KEY']!;
  static const String unsplashApiUrl = 'https://api.unsplash.com/search/photos';

  static DateTime _lastRequestTime = DateTime.now();
  static const int _maxRequestsPerDay = 3000;
  static const String _lastRequestDateKey = 'lastRequestDate';
  static const String _requestCountKey = 'requestCount';
  static const String _cacheKey = 'placeCache';
  static const Duration _cacheExpiration = Duration(days: 7);
  static const int _imagesPerRequest = 5;

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
    String uniqueString =
        '${place['name']}${place['formatted']}${place['country']}';
    var bytes = utf8.encode(uniqueString);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  static Future<Map<String, dynamic>> fetchPlaceDetails(
      String query, String userId) async {
    if (await _canMakeRequest()) {
      await _enforceRateLimit();

      try {
        final prefs = await SharedPreferences.getInstance();
        final cacheKey = 'place_$query';
        final cachedData = prefs.getString(cacheKey);

        if (cachedData != null) {
          final cachedPlace = json.decode(cachedData);
          if (DateTime.now()
                  .difference(DateTime.parse(cachedPlace['timestamp'])) <
              _cacheExpiration) {
            return cachedPlace['data'];
          }
        }

        final apis = [
          _fetchGeoapifyData,
          _fetchMapboxData,
          _fetchPexelsImages,
          _fetchUnsplashImages,
        ];

        final results = await Future.wait(apis.map((api) => api(query)));

        final placeDetails = _combineApiResults(results);

        if (placeDetails.isNotEmpty) {
          placeDetails['id'] = generatePlaceId(placeDetails);
          await prefs.setString(
              cacheKey,
              json.encode({
                'data': placeDetails,
                'timestamp': DateTime.now().toIso8601String(),
              }));
          return placeDetails;
        } else {
          print('No results found for query: $query');
          return {};
        }
      } catch (e, stackTrace) {
        print('Error in fetchPlaceDetails: $e');
        print('Stack trace: $stackTrace');
        return {};
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

  static Future<Map<String, dynamic>> _fetchGeoapifyData(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$geopifyApiUrl?text=$query&apiKey=$geopifyApiKey&country=KE'),
      );
      if (response.statusCode == 200) {
        return {'geoapify': json.decode(response.body)['features']};
      }
    } catch (e) {
      print('Geoapify API error: $e');
    }
    return {};
  }

  static Future<Map<String, dynamic>> _fetchMapboxData(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$mapboxApiUrl/$query.json?access_token=$mapboxApiKey&country=KE'),
      );
      if (response.statusCode == 200) {
        return {'mapbox': json.decode(response.body)['features']};
      }
    } catch (e) {
      print('Mapbox API error: $e');
    }
    return {};
  }

  static Future<Map<String, dynamic>> _fetchPexelsImages(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$pexelsApiUrl?query=$query&per_page=$_imagesPerRequest'),
        headers: {'Authorization': pexelsApiKey},
      );
      if (response.statusCode == 200) {
        return {'pexels': json.decode(response.body)['photos']};
      }
    } catch (e) {
      print('Pexels API error: $e');
    }
    return {};
  }

  static Future<Map<String, dynamic>> _fetchUnsplashImages(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$unsplashApiUrl?query=$query&client_id=$unsplashApiKey&per_page=$_imagesPerRequest'),
      );
      if (response.statusCode == 200) {
        return {'unsplash': json.decode(response.body)['results']};
      }
    } catch (e) {
      print('Unsplash API error: $e');
    }
    return {};
  }

  static Map<String, dynamic> _combineApiResults(
      List<Map<String, dynamic>> results) {
    final geoapifyData = results.firstWhere((r) => r.containsKey('geoapify'),
        orElse: () => {})['geoapify'];
    final mapboxData = results.firstWhere((r) => r.containsKey('mapbox'),
        orElse: () => {})['mapbox'];
    final pexelsData = results.firstWhere((r) => r.containsKey('pexels'),
        orElse: () => {})['pexels'];
    final unsplashData = results.firstWhere((r) => r.containsKey('unsplash'),
        orElse: () => {})['unsplash'];

    if ((geoapifyData?.isEmpty ?? true) && (mapboxData?.isEmpty ?? true)) {
      return {};
    }

    final geoapifyPlace =
        geoapifyData?.isNotEmpty == true ? geoapifyData[0]['properties'] : null;
    final mapboxPlace = mapboxData?.isNotEmpty == true ? mapboxData[0] : null;

    List<String> images = [];
    if (pexelsData != null) {
      images.addAll((pexelsData as List)
          .map((image) => (image['src']['medium'] ?? '').toString())
          .where((url) => url.isNotEmpty));
    }
    if (unsplashData != null) {
      images.addAll((unsplashData as List)
          .map((image) => (image['urls']['regular'] ?? '').toString())
          .where((url) => url.isNotEmpty));
    }
    images = images.take(_imagesPerRequest).toList();

    List<String> categories = [];
    if (geoapifyPlace != null && geoapifyPlace['categories'] is Iterable) {
      categories.addAll((geoapifyPlace['categories'] as Iterable)
          .map((c) => c.toString())
          .where((c) => c.isNotEmpty));
    } else if (mapboxPlace != null && mapboxPlace['context'] is Iterable) {
      categories.addAll((mapboxPlace['context'] as Iterable)
          .map((item) => (item['id'] ?? '').toString())
          .where((id) => id.isNotEmpty));
    }

    return {
      'name':
          (geoapifyPlace?['name'] ?? mapboxPlace?['place_name'] ?? 'Unknown')
              .toString(),
      'lat':
          (geoapifyPlace?['lat'] ?? mapboxPlace?['center']?[1] ?? 0).toString(),
      'lon':
          (geoapifyPlace?['lon'] ?? mapboxPlace?['center']?[0] ?? 0).toString(),
      'formatted':
          (geoapifyPlace?['formatted'] ?? mapboxPlace?['place_name'] ?? '')
              .toString(),
      'categories': categories,
      'country': (geoapifyPlace?['country'] ?? 'Kenya').toString(),
      'state': (geoapifyPlace?['state'] ?? '').toString(),
      'city': (geoapifyPlace?['city'] ?? '').toString(),
      'postcode': (geoapifyPlace?['postcode'] ?? '').toString(),
      'description': (mapboxPlace?['text'] ?? '').toString(),
      'images': images,
    };
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
      return details.isNotEmpty ? [details] : [];
    } catch (e) {
      print("Error searching places: $e");
      return [];
    }
  }
}
