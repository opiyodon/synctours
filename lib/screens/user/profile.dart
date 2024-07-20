import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/models/favorite_place.dart';
import 'package:synctours/screens/user/location_detail.dart';
import 'package:synctours/screens/user/personal_information.dart';
import 'package:synctours/services/auth.dart';
import 'package:synctours/services/database.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/loading.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool _isLoggingOut = false;

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

      AuthService authService = AuthService();
      await authService.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      });
      return const Scaffold(body: Center(child: Loading()));
    }

    if (_isLoggingOut) {
      return const Scaffold(
        body: Center(
          child: Loading(),
        ),
      );
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid!).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Profile',
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
                              Text(
                                userData.fullname,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '@${userData.username}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Account settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    buildListTile(
                        Icons.person,
                        'Personal information',
                        context,
                        () => PersonalInformation(
                            userData: userData, uid: user.uid!)),
                    const SizedBox(height: 30),
                    const Text('Favorite locations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    StreamBuilder<List<FavoritePlace>>(
                      stream: DatabaseService(uid: user.uid!).favoritePlaces,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<FavoritePlace> favoritePlaces = snapshot.data!;
                          if (favoritePlaces.isEmpty) {
                            return buildListTile(
                              Icons.star_border,
                              'No favorite places yet',
                              context,
                              () => const LocationDetail(
                                name: 'No favorite places yet',
                                formatted: 'Favorite a place to view them here',
                                placeId: '0',
                              ),
                            );
                          }
                          return Column(
                            children: favoritePlaces.take(5).map((place) {
                              return buildListTile(
                                Icons.star,
                                place.name,
                                context,
                                () => LocationDetail(
                                  name: place.name,
                                  formatted: place.formatted,
                                  placeId: place.placeId,
                                ),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: AppColors.buttonText,
                          ),
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
            body: Center(child: Loading()),
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
