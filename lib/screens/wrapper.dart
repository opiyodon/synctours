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
  bool isLoading = true;
  bool isLoggedIn = false;
  bool showLogo = true;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;
    if (!hasLaunchedBefore) {
      // Show logo for 5 seconds only on the first launch
      await Future.delayed(const Duration(seconds: 5));
      prefs.setBool('hasLaunchedBefore', true);
    }
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
      isLoading = false;
      showLogo =
          false; // Stop showing the logo after the first launch or restart
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    // Show the logo screen only during the first launch or restart
    if (isLoading && showLogo) {
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
    }

    // If the user data is being determined
    if (user == null && isLoggedIn) {
      // User has logged out, update state
      setState(() {
        isLoggedIn = false;
      });
    }

    // If user is still being determined
    if (user == null && !isLoggedIn) {
      return const Authentication();
    }

    // If user is logged in or was previously logged in
    return const PopScope(
      canPop: false,
      child: Home(),
    );
  }
}
