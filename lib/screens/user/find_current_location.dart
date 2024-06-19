import 'package:flutter/material.dart';

class FindCurrentLocation extends StatelessWidget {
  const FindCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Current Location'),
      ),
      body: const Center(
        child: Text(
          'Find Current Location Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
