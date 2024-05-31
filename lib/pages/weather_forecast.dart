import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: const Center(
        child: Text(
          'Weather Forecast Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
