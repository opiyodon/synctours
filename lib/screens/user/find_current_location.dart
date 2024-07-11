import 'package:flutter/material.dart';
import 'package:synctours/screens/user/locate_in_map.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FindCurrentLocation extends StatefulWidget {
  const FindCurrentLocation({super.key});

  @override
  FindCurrentLocationState createState() => FindCurrentLocationState();
}

class FindCurrentLocationState extends State<FindCurrentLocation> {
  bool isLoading = true;
  late MapController mapController;
  LatLng? currentPosition;
  final LatLng defaultLocation =
      const LatLng(-1.2921, 36.8219); // Nairobi, Kenya
  String locationName = "Nairobi";
  String country = "Kenya";
  String continent = "Africa";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    _requestLocationPermission();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (status.isGranted) {
        _showNotification('Location Permission', 'Location access granted');
        fetchCurrentLocation();
      } else {
        _showDefaultLocation();
      }
    } else {
      fetchCurrentLocation();
    }
  }

  Future<void> fetchCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });

      mapController.move(currentPosition!, 12);
      await updatePlaceName(currentPosition!);
    } catch (e) {
      if (!mounted) return;
      _showDefaultLocation();
    }
  }

  void _showDefaultLocation() {
    setState(() {
      currentPosition = defaultLocation;
      locationName = "Nairobi";
      country = "Kenya";
      continent = "Africa";
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Unable to fetch current location. Showing default location.')),
    );
  }

  Future<void> updatePlaceName(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          locationName = place.locality ??
              place.subAdministrativeArea ??
              "Unknown Location";
          country = place.country ?? "";
          continent = getContinentForCountry(country);
        });
      }
    } catch (e) {
      setState(() {
        locationName = "Unknown Location";
        country = "";
        continent = "Unknown Continent";
      });
    }
  }

  String getContinentForCountry(String country) {
    Map<String, String> countryContinentMap = {
      "United States": "North America",
      "Canada": "North America",
      "Mexico": "North America",
      "Brazil": "South America",
      "Argentina": "South America",
      "Colombia": "South America",
      "United Kingdom": "Europe",
      "France": "Europe",
      "Germany": "Europe",
      "Italy": "Europe",
      "Spain": "Europe",
      "Russia": "Europe",
      "China": "Asia",
      "Japan": "Asia",
      "India": "Asia",
      "South Korea": "Asia",
      "Australia": "Australia",
      "New Zealand": "Australia",
      "Egypt": "Africa",
      "South Africa": "Africa",
      "Kenya": "Africa",
      "Nigeria": "Africa",
      "Morocco": "Africa",
    };
    return countryContinentMap[country] ?? "Unknown Continent";
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('location_channel', 'Location Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Current Location'),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentPosition ?? defaultLocation,
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?apiKey=${dotenv.env['GEOAPIFY_API_KEY']}",
                additionalOptions: const {
                  'attribution':
                      'Powered by <a href="https://www.geoapify.com/" target="_blank">Geoapify</a> | © OpenMapTiles © OpenStreetMap contributors',
                },
                tileProvider: NetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPosition ?? defaultLocation,
                    width: 80.0,
                    height: 80.0,
                    child: Image.network(
                      'https://api.geoapify.com/v1/icon/?type=material&color=red&size=large&icon=location_on&apiKey=${dotenv.env['GEOAPIFY_API_KEY']}',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isLoading) const Loading(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$locationName, $country",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                continent,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: fetchCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                        ),
                        icon: const Icon(Icons.refresh,
                            color: AppColors.buttonText),
                        label: const Text('Refresh',
                            style: TextStyle(color: AppColors.buttonText)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LocateInMap(location: locationName),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        icon:
                            const Icon(Icons.map, color: AppColors.buttonText),
                        label: const Text('Locate in Map',
                            style: TextStyle(color: AppColors.buttonText)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 220,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, color: AppColors.buttonText),
                  onPressed: () {
                    mapController.move(mapController.camera.center,
                        mapController.camera.zoom + 1);
                  },
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.remove, color: AppColors.buttonText),
                  onPressed: () {
                    mapController.move(mapController.camera.center,
                        mapController.camera.zoom - 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
