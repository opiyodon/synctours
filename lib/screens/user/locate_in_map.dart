import 'package:flutter/material.dart';

class LocateInMap extends StatelessWidget {
  const LocateInMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate in Map'),
      ),
      body: const Center(
        child: Text(
          'Locate in Map Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
