import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePlace {
  final String placeId;
  final String name;
  final String formatted;
  final String image;
  final bool isFavorite;
  final String uid;
  final DateTime? timestamp;

  FavoritePlace({
    required this.placeId,
    required this.name,
    required this.formatted,
    required this.image,
    required this.isFavorite,
    required this.uid,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'name': name,
      'formatted': formatted,
      'image': image,
      'isFavorite': isFavorite,
      'uid': uid,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory FavoritePlace.fromMap(Map<String, dynamic> map) {
    return FavoritePlace(
      placeId: map['placeId'] ?? '',
      name: map['name'] ?? '',
      formatted: map['formatted'] ?? '',
      image: map['image'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      uid: map['uid'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  FavoritePlace copyWith({
    String? placeId,
    String? name,
    String? formatted,
    String? image,
    bool? isFavorite,
    String? uid,
    DateTime? timestamp,
  }) {
    return FavoritePlace(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      formatted: formatted ?? this.formatted,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
