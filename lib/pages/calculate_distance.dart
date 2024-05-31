import 'package:flutter/material.dart';

class CalculateDistance extends StatelessWidget {
  const CalculateDistance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Distance'),
      ),
      body: const Center(
        child: Text(
          'Calculate Distance Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
