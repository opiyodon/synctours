import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Login',
          style:
              TextStyle(color: AppColors.buttonText), // Text color set to white
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
            color: AppColors.buttonText), // Back arrow color set to white
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.loadingBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  hintStyle: const TextStyle(color: AppColors.buttonText),
                  filled: true,
                  fillColor: AppColors.authInput,
                  contentPadding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.authInputText),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: AppColors.buttonText),
                  filled: true,
                  fillColor: AppColors.authInput,
                  contentPadding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.authInputText),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Functionality for login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors
                      .accent, // Using brown accent for button background
                  padding: const EdgeInsets.symmetric(
                      horizontal: 130.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18.0,
                    color:
                        AppColors.buttonText, // Using white color for contrast
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: AppColors.buttonText),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-up page
                      Navigator.pushNamed(context, '/sign_up');
                    },
                    child: const Text(
                      'Sign Up here!',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "-------------   or log in with   -------------",
                style: TextStyle(color: AppColors.buttonText),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1), // Adjust padding as needed
                    decoration: const BoxDecoration(
                      color: AppColors.authInput,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                          'assets/icon/google.png',
                          width: 50.0,
                          height: 50.0,
                      ),
                      onPressed: () {
                        // Handle Google button tap
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(6), // Adjust padding as needed
                    decoration: const BoxDecoration(
                      color: AppColors.authInput,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                          'assets/icon/apple.png',
                          width: 35.0,
                          height: 35.0
                      ),
                      onPressed: () {
                        // Handle Apple button tap
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
