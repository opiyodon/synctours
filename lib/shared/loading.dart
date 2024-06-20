import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:synctours/theme/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.loadingBackground,
        ),
        child: const Center(
          child: SpinKitChasingDots(
            color: AppColors.accent,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
