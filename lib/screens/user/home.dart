import 'package:flutter/material.dart';
import 'package:synctours/shared/brand_name.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: const Text('Home'),
    );
  }
}