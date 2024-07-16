import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/screens/auth/authentication.dart';
import 'package:synctours/screens/user/home.dart';
import 'package:synctours/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.loadingBackground,
          ),
          child: Center(
            child: Image.asset(
              'assets/icon/logo.png',
              width: 220.0,
              height: 220.0,
            ),
          ),
        ),
      );
    } else {
      final user = Provider.of<CustomUser?>(context);
      if (user != null || _isLoggedIn) {
        return const PopScope(
          canPop: false,
          child: Home(),
        );
      } else {
        return const Authentication();
      }
    }
  }
}
