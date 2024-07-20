import 'package:flutter/material.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:synctours/theme/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synctours/widgets/loading.dart';

class CalculateDistance extends StatefulWidget {
  final String location;

  const CalculateDistance({super.key, required this.location});

  @override
  CalculateDistanceState createState() => CalculateDistanceState();
}

class CalculateDistanceState extends State<CalculateDistance> {
  bool isLoading = false;
  String distance = '';
  String durationDrivingStr = '';
  String durationMotorcycleStr = '';
  String durationWalkingStr = '';
  late TextEditingController startController;
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startController =
        TextEditingController(text: _formatLocation(widget.location));
    _requestLocationPermission();
  }

  String _formatLocation(String location) {
    List<String> parts = location.split(',');
    return parts.isNotEmpty ? parts[0].trim() : location.trim();
  }

  @override
  void dispose() {
    startController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission is required for accurate distance calculation.')),
      );
    }
  }

  Future<void> calculateDistance() async {
    if (startController.text.isEmpty || destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both start and destination')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Location> startLocations =
          await locationFromAddress(startController.text);
      List<Location> endLocations =
          await locationFromAddress(destinationController.text);

      if (startLocations.isNotEmpty && endLocations.isNotEmpty) {
        double distanceInMeters = Geolocator.distanceBetween(
          startLocations.first.latitude,
          startLocations.first.longitude,
          endLocations.first.latitude,
          endLocations.first.longitude,
        );

        double distanceInKm = distanceInMeters / 1000;
        double durationDriving = distanceInKm / 60;
        double durationMotorcycle = distanceInKm / 50;
        double durationWalking = distanceInKm / 5;

        setState(() {
          distance = '${distanceInKm.toStringAsFixed(2)} km';
          durationDrivingStr = '${durationDriving.toStringAsFixed(2)} hours';
          durationMotorcycleStr =
              '${durationMotorcycle.toStringAsFixed(2)} hours';
          durationWalkingStr = '${durationWalking.toStringAsFixed(2)} hours';
        });
      } else {
        throw Exception('Location not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating distance: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Distance Calculator',
            actions: [],
          ),
          drawer: const CustomDrawer(),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: startController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter start location',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => calculateDistance(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: destinationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter destination',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => calculateDistance(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : calculateDistance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          isLoading ? 'Calculating' : 'Calculate',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: AppColors.buttonText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (distance.isNotEmpty)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Results',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                ResultItem(
                                  icon: Icons.straighten,
                                  title: 'Distance',
                                  subtitle: distance,
                                ),
                                const SizedBox(height: 16),
                                ResultItem(
                                  icon: Icons.directions_car,
                                  title: 'Driving',
                                  subtitle: durationDrivingStr,
                                ),
                                const SizedBox(height: 8),
                                ResultItem(
                                  icon: Icons.motorcycle,
                                  title: 'Motorcycle',
                                  subtitle: durationMotorcycleStr,
                                ),
                                const SizedBox(height: 8),
                                ResultItem(
                                  icon: Icons.directions_walk,
                                  title: 'Walking',
                                  subtitle: durationWalkingStr,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Loading(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ResultItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ResultItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
