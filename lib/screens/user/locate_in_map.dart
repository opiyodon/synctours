import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:synctours/widgets/loading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocateInMap extends StatefulWidget {
  final String location;

  const LocateInMap({super.key, required this.location});

  @override
  LocateInMapState createState() => LocateInMapState();
}

class LocateInMapState extends State<LocateInMap> {
  bool isLoading = true;
  late MapController mapController;
  LatLng? currentPosition;
  final LatLng defaultLocation =
      const LatLng(-1.2921, 36.8219); // Nairobi, Kenya
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> nearbyPlaces = [];
  int? selectedPlaceIndex;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    searchController.text = widget.location;
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      await fetchLocation();
    } else {
      _showDefaultLocation();
    }
  }

  Future<void> fetchLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.location.isEmpty) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          currentPosition = LatLng(position.latitude, position.longitude);
        });
      } else {
        List<Location> locations = await locationFromAddress(widget.location);
        if (locations.isNotEmpty) {
          setState(() {
            currentPosition =
                LatLng(locations[0].latitude, locations[0].longitude);
          });
        }
      }

      if (currentPosition == null) {
        setState(() {
          currentPosition = defaultLocation;
        });
      }

      mapController.move(currentPosition!, 12);
      await fetchNearbyPlaces();
    } catch (e) {
      _showDefaultLocation();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDefaultLocation() {
    setState(() {
      currentPosition = defaultLocation;
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Unable to fetch location. Showing default location.')),
    );
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        setState(() {
          currentPosition =
              LatLng(locations[0].latitude, locations[0].longitude);
          mapController.move(currentPosition!, 12);
        });
        await fetchNearbyPlaces();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error: Unable to fetch searched location.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchNearbyPlaces() async {
    if (currentPosition == null) return;

    final apiKey = dotenv.env['GEOAPIFY_API_KEY'];
    final url = 'https://api.geoapify.com/v2/places?'
        'categories=tourism,entertainment'
        '&filter=circle:${currentPosition!.longitude},${currentPosition!.latitude},5000'
        '&bias=proximity:${currentPosition!.longitude},${currentPosition!.latitude}'
        '&limit=5'
        '&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nearbyPlaces = List<Map<String, dynamic>>.from(data['features']);
      });
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  void _onPlaceCardTapped(int index) {
    setState(() {
      selectedPlaceIndex = index;
    });
    final place = nearbyPlaces[index];
    final coordinates = place['geometry']['coordinates'];
    final newPosition = LatLng(coordinates[1], coordinates[0]);
    mapController.move(newPosition, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Locate in Map'),
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
                  ...nearbyPlaces.asMap().entries.map((entry) {
                    final index = entry.key;
                    final place = entry.value;
                    final coordinates = place['geometry']['coordinates'];
                    return Marker(
                      point: LatLng(coordinates[1], coordinates[0]),
                      width: 80.0,
                      height: 80.0,
                      child: Icon(
                        Icons.place,
                        color: selectedPlaceIndex == index
                            ? Colors.red
                            : Colors.blue,
                        size: selectedPlaceIndex == index ? 50 : 40,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          if (isLoading) const Loading(),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: searchLocation,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Nearby Places',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: nearbyPlaces.length,
                      itemBuilder: (context, index) {
                        final place = nearbyPlaces[index]['properties'];
                        return GestureDetector(
                          onTap: () => _onPlaceCardTapped(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectedPlaceIndex == index
                                    ? Colors.blue[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: selectedPlaceIndex == index
                                          ? Colors.blue
                                          : Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place['name'] ?? 'Unnamed Place',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: selectedPlaceIndex == index
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          place['address_line2'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: selectedPlaceIndex == index
                                                ? Colors.blue[700]
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
