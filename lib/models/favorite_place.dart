class FavoritePlace {
  final String id;
  final String name;
  final String formatted;
  final String image;
  final bool isFavorite;
  final String uid;

  FavoritePlace({
    required this.id,
    required this.name,
    required this.formatted,
    required this.image,
    required this.isFavorite,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'formatted': formatted,
      'image': image,
      'isFavorite': isFavorite,
      'uid': uid,
    };
  }

  factory FavoritePlace.fromMap(Map<String, dynamic> map) {
    return FavoritePlace(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      formatted: map['formatted'] ?? '',
      image: map['image'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      uid: map['uid'] ?? '',
    );
  }

  FavoritePlace copyWith({
    String? id,
    String? name,
    String? formatted,
    String? image,
    bool? isFavorite,
    String? uid,
  }) {
    return FavoritePlace(
      id: id ?? this.id,
      name: name ?? this.name,
      formatted: formatted ?? this.formatted,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      uid: uid ?? this.uid,
    );
  }
}
