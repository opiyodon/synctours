import 'package:flutter/material.dart';
import 'package:synctours/widgets/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:synctours/widgets/custom_drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:synctours/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherForecast extends StatefulWidget {
  final String? location;

  const WeatherForecast({super.key, this.location});

  @override
  WeatherForecastState createState() => WeatherForecastState();
}

class WeatherForecastState extends State<WeatherForecast> {
  final String apiKey = dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';
  final TextEditingController locationController = TextEditingController();
  WeatherData? weatherData;
  List<ForecastData> forecastData = [];
  bool isLoading = true;
  final LatLng defaultLocation =
  const LatLng(-1.2921, 36.8219); // Nairobi, Kenya

  @override
  void initState() {
    super.initState();
    _initializeLocationAndWeather();
  }

  Future<void> _initializeLocationAndWeather() async {
    if (widget.location != null) {
      await fetchWeatherData(widget.location!);
    } else {
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (status.isGranted) {
        await _getCurrentLocation();
      } else {
        await _showDefaultLocationWeather();
      }
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await fetchWeatherDataByCoordinates(
          position.latitude, position.longitude);
    } catch (e) {
      await _showDefaultLocationWeather();
    }
  }

  Future<void> _showDefaultLocationWeather() async {
    await fetchWeatherDataByCoordinates(
        defaultLocation.latitude, defaultLocation.longitude);
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    setState(() {
      isLoading = true;
    });
    try {
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final weatherJsonData = jsonDecode(weatherResponse.body);
        final forecastJsonData = jsonDecode(forecastResponse.body);

        setState(() {
          weatherData = WeatherData.fromJson(weatherJsonData);
          forecastData = processFiveDayForecast(forecastJsonData['list']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    }
  }

  Future<void> fetchWeatherData(String location) async {
    if (location.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=$apiKey'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final weatherJsonData = jsonDecode(weatherResponse.body);
        final forecastJsonData = jsonDecode(forecastResponse.body);

        if (weatherJsonData != null && forecastJsonData != null) {
          setState(() {
            weatherData = WeatherData.fromJson(weatherJsonData);
            forecastData = processFiveDayForecast(forecastJsonData['list']);
            isLoading = false;
            locationController.clear();
          });
        } else {
          throw Exception('Failed to decode JSON');
        }
      } else {
        throw Exception(
            'The place you searched for is not a town or city. Enter a town or city to get weather details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    }
  }

  List<ForecastData> processFiveDayForecast(List<dynamic> forecastList) {
    Map<String, ForecastData> dailyForecasts = {};

    for (var item in forecastList) {
      DateTime date = DateTime.parse(item['dt_txt']);
      String dayName = DateFormat('EEEE').format(date);

      if (!dailyForecasts.containsKey(dayName)) {
        dailyForecasts[dayName] = ForecastData(
          date: dayName,
          minTemp: item['main']['temp_min'].toDouble(),
          maxTemp: item['main']['temp_max'].toDouble(),
        );
      } else {
        ForecastData existingForecast = dailyForecasts[dayName]!;
        existingForecast.minTemp =
            min(existingForecast.minTemp, item['main']['temp_min'].toDouble());
        existingForecast.maxTemp =
            max(existingForecast.maxTemp, item['main']['temp_max'].toDouble());
      }
    }

    return dailyForecasts.values.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Weather Forecast',
        actions: [],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _initializeLocationAndWeather(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4EFE6), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter location for weather',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      fetchWeatherData(value);
                    }
                  },
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Loading()
                    : weatherData != null
                    ? buildWeatherContent()
                    : const Center(
                  child: Text(
                      'Unable to fetch weather data. Please try again.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWeatherContent() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Color(0xFF1C160C), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    weatherData!.location,
                    style: const TextStyle(
                      color: Color(0xFF1C160C),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${weatherData!.temperature}°C ${weatherData!.description}',
                style: const TextStyle(
                  color: Color(0xFF1C160C),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'H: ${weatherData!.highTemp}° L: ${weatherData!.lowTemp}°',
                style: const TextStyle(
                  color: Color(0xFFA18249),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '5-day forecast',
                style: TextStyle(
                  color: Color(0xFF1C160C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...forecastData.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.date,
                        style: const TextStyle(
                          color: Color(0xFFA18249),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${data.minTemp.toStringAsFixed(1)}° - ${data.maxTemp.toStringAsFixed(1)}°',
                        style: const TextStyle(
                          color: Color(0xFF1C160C),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              InfoCard(
                title: 'Wind',
                value: '${weatherData!.windSpeed} mph',
                imageUrl:
                'https://cdn.usegalileo.ai/stability/e2f5c438-6425-478d-b1ea-9137627a1a6f.png',
              ),
              InfoCard(
                title: 'Humidity',
                value: '${weatherData!.humidity}%',
                imageUrl:
                'https://cdn.usegalileo.ai/stability/242da4ba-92f9-4014-b959-df0cdbb78e16.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String imageUrl;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C160C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFFA18249),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherData {
  final String location;
  final double temperature;
  final double highTemp;
  final double lowTemp;
  final double windSpeed;
  final int humidity;
  final String description;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.windSpeed,
    required this.humidity,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      highTemp: json['main']['temp_max'].toDouble(),
      lowTemp: json['main']['temp_min'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'].toInt(),
      description: json['weather'][0]['main'],
    );
  }
}

class ForecastData {
  final String date;
  double minTemp;
  double maxTemp;

  ForecastData({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}