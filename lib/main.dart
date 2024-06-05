import 'package:flutter/material.dart';
import 'package:synctours/pages/home.dart';
import 'package:synctours/pages/loading.dart';
import 'package:synctours/pages/authentication.dart';
import 'package:synctours/pages/find_current_location.dart';
import 'package:synctours/pages/locate_in_map.dart';
import 'package:synctours/pages/login.dart';
import 'package:synctours/pages/sign_up.dart';
import 'package:synctours/pages/video_search.dart';
import 'package:synctours/pages/weather_forecast.dart';
import 'package:synctours/pages/calculate_distance.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/authentication': (context) => const Authentication(),
      '/login': (context) => const Login(),
      '/sign_up': (context) => const SignUp(),
      '/home': (context) => const Home(),
      '/find_current_location': (context) => const FindCurrentLocation(),
      '/locate_in_map': (context) => const LocateInMap(),
      '/video_search': (context) => const VideoSearch(),
      '/weather_forecast': (context) => const WeatherForecast(),
      '/calculate_distance': (context) => const CalculateDistance(),
    },
  ));
}
