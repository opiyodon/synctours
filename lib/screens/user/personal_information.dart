import 'package:flutter/material.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/services/database.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullname);
    _usernameController = TextEditingController(text: widget.userData.username);
    _phoneNumberController =
        TextEditingController(text: widget.userData.phoneNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
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
      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Card(
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
                        child:
                            Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildInfoSection('Full Name', _fullNameController),
                    buildInfoSection('Username', _usernameController),
                    buildInfoSection('Phone Number', _phoneNumberController),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: AppColors.buttonText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
            onFieldSubmitted: (_) => _updateUserInfo(),
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
}
