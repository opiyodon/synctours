import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

Widget brandName() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Sync',
        style: TextStyle(
          color: AppColors.buttonText,
        ),
      ),
      Text(
        'Tours',
        style: TextStyle(
          color: AppColors.accent,
        ),
      ),
    ],
  );
}
