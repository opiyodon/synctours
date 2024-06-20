import 'package:flutter/material.dart';
import 'package:synctours/screens/auth/authentication.dart';
import 'package:synctours/screens/auth/login.dart';
import 'package:synctours/screens/auth/register.dart';
import 'package:synctours/screens/user/calculate_distance.dart';
import 'package:synctours/screens/user/find_current_location.dart';
import 'package:synctours/screens/user/home.dart';
import 'package:synctours/screens/user/locate_in_map.dart';
import 'package:synctours/screens/user/video_search.dart';
import 'package:synctours/screens/user/weather_forecast.dart';
import 'package:synctours/screens/wrapper.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Wrapper(),
      '/authentication': (context) => const Authentication(),
      '/login': (context) => const Login(),
      '/register': (context) => const Register(),
      '/home': (context) => const Home(),
      '/find_current_location': (context) => const FindCurrentLocation(),
      '/locate_in_map': (context) => const LocateInMap(),
      '/video_search': (context) => const VideoSearch(),
      '/weather_forecast': (context) => const WeatherForecast(),
      '/calculate_distance': (context) => const CalculateDistance(),
    },
  ));
}
