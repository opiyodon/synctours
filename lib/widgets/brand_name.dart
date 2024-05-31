import 'package:flutter/material.dart';

Widget brandName () {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
          'Sync',
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      Text(
          'Tours',
        style: TextStyle(
          color: Colors.amber,
        ),
      ),
    ],
  );
}
