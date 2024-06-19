import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

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
