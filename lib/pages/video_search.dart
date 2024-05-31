import 'package:flutter/material.dart';

class VideoSearch extends StatelessWidget {
  const VideoSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Search'),
      ),
      body: const Center(
        child: Text(
          'Video Search Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
