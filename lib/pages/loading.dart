import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    // Add your data fetching logic here
    // For example, you can use Future.delayed to simulate data fetching
    Future.delayed(const Duration(hours: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loadingBackground,
      body: Center(
        child: Image.asset(
          'assets/icon/logo.png',
          width: 170.0,
          height: 180.0,
        ),
      ),
    );
  }
}

