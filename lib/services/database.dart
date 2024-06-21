import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synctours/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future updateUserData(String fullname, String username, String phoneNumber) async {
    return await userCollection.doc(uid).set({
      'fullname': fullname,
      'username': username,
      'phoneNumber': phoneNumber,
    });
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
}