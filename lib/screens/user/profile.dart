import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/services/auth.dart';
import 'package:synctours/services/database.dart';
import 'package:synctours/theme/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  bool isEditingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditName() {
    setState(() {
      isEditingName = !isEditingName;
    });
  }

  void _editProfile(String uid) async {
    if (isEditingName) {
      await DatabaseService(uid: uid).updateUserData(
        _nameController.text,
        '', // Keeping username and phone number unchanged
        '',
      );
      _toggleEditName();
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid!).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          _nameController.text = userData.fullname;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.accent,
                            child: Icon(Icons.person,
                                size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isEditingName)
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              else
                                Text(
                                  userData.fullname,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              IconButton(
                                icon: Icon(
                                    isEditingName ? Icons.check : Icons.edit),
                                color: AppColors.primary,
                                onPressed: () {
                                  if (isEditingName) {
                                    _editProfile(user.uid!);
                                  } else {
                                    _toggleEditName();
                                  }
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Username: ${userData.username}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Account settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    buildListTile(Icons.person, 'Personal information', context,
                        () => PersonalInformationPage(userData: userData)),
                    buildListTile(Icons.lock, 'Privacy and sharing', context,
                        () => const PrivacyAndSharingPage()),
                    const SizedBox(height: 30),
                    const Text('Favorite locations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    buildListTile(
                        Icons.star,
                        'Nakuru',
                        context,
                        () => const LocationDetailPage(
                            'Nakuru', 'Added on June 2024')),
                    buildListTile(
                        Icons.star,
                        'Mombasa',
                        context,
                        () => const LocationDetailPage(
                            'Mombasa', 'Added on June 2024')),
                    const SizedBox(height: 30),
                    const Text('Travel history',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    buildListTile(Icons.flight, 'Malindi', context,
                        () => const TravelHistoryPage('Malindi', 'June 2024')),
                    buildListTile(Icons.flight, 'Nairobi', context,
                        () => const TravelHistoryPage('Nairobi', 'June 2024')),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child:
                              Text('Log out', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context,
      Widget Function() navigateToPage) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
      onTap: () => _navigateTo(context, navigateToPage()),
    );
  }
}

class PersonalInformationPage extends StatelessWidget {
  final UserData userData;

  const PersonalInformationPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: ${userData.fullname}'),
            Text('Username: ${userData.username}'),
            Text('Phone Number: ${userData.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}

class PrivacyAndSharingPage extends StatelessWidget {
  const PrivacyAndSharingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Sharing'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Privacy and Sharing Page'),
      ),
    );
  }
}

class LocationDetailPage extends StatelessWidget {
  final String location;
  final String details;

  const LocationDetailPage(this.location, this.details, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(details),
      ),
    );
  }
}

class TravelHistoryPage extends StatelessWidget {
  final String location;
  final String date;

  const TravelHistoryPage(this.location, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text('Travelled on $date'),
      ),
    );
  }
}
