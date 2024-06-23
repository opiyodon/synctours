import 'package:flutter/material.dart';
import 'package:synctours/models/user.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:synctours/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(StreamProvider<CustomUser?>.value(
    value: AuthService().user,
    initialData: null,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      routes: {
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
    ),
  ));
}
