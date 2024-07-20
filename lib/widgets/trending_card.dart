import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:synctours/screens/user/place_details.dart';

class TrendingCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Map<String, dynamic> placeDetails;
  final String placeId;

  const TrendingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.placeDetails,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetails(
              place: placeDetails,
              placeId: placeId,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 120.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
