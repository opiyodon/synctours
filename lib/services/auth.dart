import 'package:firebase_auth/firebase_auth.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // signInWithEmailAndPassword
  Future<CustomUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // registerWithEmailAndPassword
  Future<CustomUser?> registerWithEmailAndPassword(
      String email,
      String password,
      String fullname,
      String username,
      String phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid)
          .updateUserData(fullname, username, phoneNumber);
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // deleteUser
  Future<void> deleteUser(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Reauthenticate user before deletion
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        // Delete user
        await user.delete();
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle error
    }
  }
}
