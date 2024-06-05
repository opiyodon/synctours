import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart'; // Assuming you have a custom color file

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Using warm red as the background color
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/icon/logo.png',
                width: 150.0, // Adjust size as needed
                height: 150.0,
              ),
              const SizedBox(height: 40.0),
              const Text(
                'Welcome!\nYour number 1 travel guide!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.buttonText, // Using white color for contrast
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the login page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground, // Using brown accent for button background
                  padding: const EdgeInsets.symmetric(horizontal: 130.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.buttonText, // Using white color for contrast
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the sign-up page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 130.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: AppColors.primary), // Using warm red as border color
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.primary, // Using warm red as text color
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  // Continue as guest action
                },
                child: const Text(
                  'Continue as guest',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.authMainText, // Using white color for contrast
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/icon/logo.png',
                width: 100.0, // Adjust size as needed
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
