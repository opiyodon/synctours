import 'package:flutter/material.dart';
import 'package:synctours/widgets/brand_name.dart';
import 'package:synctours/theme/colors.dart';
import 'find_current_location.dart';
import 'locate_in_map.dart';
import 'video_search.dart';
import 'weather_forecast.dart';
import 'calculate_distance.dart';

void main() {
  runApp(SyncToursApp());
}

class SyncToursApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    LocateInMap(),
    VideoSearch(),
    WeatherForecast(),
    CalculateDistance(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        backgroundColor: AppColors.navbarBackground, // Set the background color of the AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.navbarBackground,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Video Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions),
            label: 'Distance',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.iconColor, // Optional: Set the color for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<City> cities = [
    City('Watamu Beach, Mombasa', 'Mostly Clear', 18, 'assets/beach.jpg'),
    City('Lake Nakuru', 'Mostly Sunny', 14, 'assets/lake_nakuru.jpg'),
    City('Nairobi City', 'Cloudy', 4, 'assets/nairobi.jpeg'),
    City('Lewa Wildlife Conservancy, Meru', 'Mostly Sunny', 26, 'assets/eland.jpg'),
    City('Mombasa City Skyline', 'Mostly Clear', 16, 'assets/mombasa-skyline.jpg'),
    City('Lewa Wildlife Conservancy, Meru', 'Mostly Sunny', 26, 'assets/wild.jpg'),
    City('Mombasa City', 'Mostly Clear', 16, 'assets/mombasa.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cities.map((city) => CityTile(city)).toList(),
    );
  }
}

class City {
  final String name;
  final String weather;
  final int temperature;
  final String imagePath;

  City(this.name, this.weather, this.temperature, this.imagePath);
}

class CityTile extends StatelessWidget {
  final City city;

  CityTile(this.city);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(city.imagePath, width: 100, height: 100, fit: BoxFit.cover),
      title: Text(city.name),
      subtitle: Text('${city.weather} ${city.temperature}°'),
      trailing: Text('${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute.toString().padLeft(2, '0')}'),
    );
  }
}
