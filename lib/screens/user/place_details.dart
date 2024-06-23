import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlaceDetails extends StatelessWidget {
  final Map<String, dynamic> placeDetails;

  const PlaceDetails({super.key, required this.placeDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeDetails['name'] ?? 'Place Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (placeDetails['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: placeDetails['imageUrl'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              const SizedBox(height: 16.0),
              Text(
                placeDetails['name'] ?? 'Unknown Place',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                placeDetails['formatted'] ?? 'No address available',
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Text(
                placeDetails['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16.0),
              ),
              if (placeDetails['categories'] != null) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Categories:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: (placeDetails['categories'] as List<dynamic>)
                      .map((category) => Chip(label: Text(category)))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
