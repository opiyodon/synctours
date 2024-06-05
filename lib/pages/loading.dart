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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/authentication_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.loadingBackground,
      body: Center(
        child: Image(
          image: AssetImage('assets/icon/logo.png'),
        ),
      ),
    );
  }
}

