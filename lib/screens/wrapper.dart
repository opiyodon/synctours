import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/screens/auth/authentication.dart';
import 'package:synctours/screens/user/home.dart';
import 'package:synctours/theme/colors.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        navigateToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void navigateToNextScreen() {
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authentication()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
}