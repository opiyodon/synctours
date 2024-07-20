import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synctours/models/favorite_place.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/models/recent_search.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference recentSearchCollection =
      FirebaseFirestore.instance.collection('recent_searches');
  final CollectionReference favoritePlacesCollection =
      FirebaseFirestore.instance.collection('favorite_places');

  Future<void> updateUserData(
      String fullname, String username, String phoneNumber) async {
    try {
      await userCollection.doc(uid).set({
        'fullname': fullname,
        'username': username,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return UserData(
      uid: uid,
      fullname: data?['fullname'] ?? '',
      username: data?['username'] ?? '',
      phoneNumber: data?['phoneNumber'] ?? '',
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> saveRecentSearch(String query) async {
    try {
      RecentSearch recentSearch = RecentSearch(
        uid: uid,
        query: query,
        timestamp: DateTime.now(),
      );
      await recentSearchCollection.add(recentSearch.toMap());
    } catch (e) {
      print('Error saving recent search: $e');
      rethrow;
    }
  }

  Stream<List<RecentSearch>> get recentSearches {
    try {
      return recentSearchCollection
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return RecentSearch.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching recent searches: $e');
      return Stream.value([]);
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      var searchesToDelete =
          await recentSearchCollection.where('uid', isEqualTo: uid).get();
      for (var doc in searchesToDelete.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing recent searches: $e');
      rethrow;
    }
  }

  Future<void> toggleFavoritePlace(FavoritePlace place) async {
    try {
      final docRef = favoritePlacesCollection
          .where('uid', isEqualTo: uid)
          .where('placeId', isEqualTo: place.placeId)
          .limit(1);

      final querySnapshot = await docRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update existing document
        await querySnapshot.docs.first.reference.update({
          'isFavorite': place.isFavorite,
          'timestamp': place.isFavorite ? FieldValue.serverTimestamp() : null,
        });
      } else {
        // Create new document
        await favoritePlacesCollection.add({
          ...place.toMap(),
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling favorite place: $e');
      rethrow;
    }
  }

  Stream<bool> isPlaceFavoriteStream(String placeId) {
    if (placeId.isEmpty) {
      return Stream.value(false);
    }
    return favoritePlacesCollection
        .where('uid', isEqualTo: uid)
        .where('placeId', isEqualTo: placeId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return data['isFavorite'] ?? false;
      }
      return false;
    });
  }

  Stream<List<FavoritePlace>> get favoritePlaces {
    return favoritePlacesCollection
        .where('uid', isEqualTo: uid)
        .where('isFavorite', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              FavoritePlace.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<FavoritePlace?> getFavoritePlace(String placeId) async {
    try {
      final docSnapshot = await favoritePlacesCollection
          .where('uid', isEqualTo: uid)
          .where('placeId', isEqualTo: placeId)
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        return FavoritePlace.fromMap(
            docSnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching favorite place: $e');
      return null;
    }
  }

  Future<bool> isPlaceFavorite(String placeId) async {
    try {
      final docSnapshot = await favoritePlacesCollection
          .where('uid', isEqualTo: uid)
          .where('placeId', isEqualTo: placeId)
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data() as Map<String, dynamic>;
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking if place is favorite: $e');
      return false;
    }
  }
}
