import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  const SizedBox(
                      height: 10.0), // Add space between the image and text
                  const Text(
                    'SyncTours',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigate to home
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Current Location'),
            onTap: () {
              // Navigate to weather forecast page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Locate In Map'),
            onTap: () {
              // Navigate to locate in map page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Distance Calculator'),
            onTap: () {
              // Navigate to distance calculator page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Video Search'),
            onTap: () {
              // Navigate to video search page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Weather Forecast'),
            onTap: () {
              // Navigate to weather forecast page
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
