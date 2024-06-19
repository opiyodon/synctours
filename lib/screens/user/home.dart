import 'package:flutter/material.dart';
import 'package:synctours/shared/brand_name.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: const Text('Home'),
    );
  }
}
