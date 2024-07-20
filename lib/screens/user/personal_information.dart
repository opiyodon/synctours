import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/services/auth.dart';
import 'package:synctours/services/database.dart';
import 'package:synctours/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  final UserData userData;
  final String uid;

  const PersonalInformation(
      {super.key, required this.userData, required this.uid});

  @override
  PersonalInformationState createState() => PersonalInformationState();
}

class PersonalInformationState extends State<PersonalInformation> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullname);
    _usernameController = TextEditingController(text: widget.userData.username);
    _phoneNumberController =
        TextEditingController(text: widget.userData.phoneNumber);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await DatabaseService(uid: widget.uid).updateUserData(
          _fullNameController.text,
          _usernameController.text,
          _phoneNumberController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Information updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating information: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Reauthenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _passwordController.text,
          );
          await user.reauthenticateWithCredential(credential);

          // Delete user data from Firestore
          await DatabaseService(uid: user.uid).deleteUserData();

          // Delete the user from Firebase Auth
          await AuthService().deleteUser(_passwordController.text);

          // Log out the user
          await _logout();

          // Navigate to the home screen
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully')),
          );
        } else {
          throw Exception('No user is currently signed in');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      AuthService authService = AuthService();
      await authService.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(color: AppColors.buttonText),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColors.buttonText,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildProfileInfoCard(),
                    const SizedBox(height: 20),
                    buildDeleteAccountCard(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Loading(),
              ),
            ),
        ],
      ),
    );
  }

  Card buildProfileInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.accent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            buildInfoSection('Full Name', _fullNameController),
            buildInfoSection('Username', _usernameController),
            buildInfoSection('Phone Number', _phoneNumberController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text('Save Changes',
                    style: TextStyle(color: AppColors.buttonText)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildDeleteAccountCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red,
                child: Icon(Icons.delete, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Danger Zone',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Deleting your account is permanent and cannot be undone. All your data will be removed.',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            buildDeleteSection('Password', _passwordController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _deleteUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text('Delete Account',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSection(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: const Icon(Icons.edit),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
            onFieldSubmitted: (_) => _isLoading ? null : _updateUserInfo(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $title';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildDeleteSection(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your password',
              suffixIcon: const Icon(Icons.lock, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
            onFieldSubmitted: (_) => _isLoading ? null : _deleteUser(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
