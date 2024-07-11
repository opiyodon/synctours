import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

Widget brandName(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: AppColors.buttonText,
        ),
      ),
    ],
  );
}
