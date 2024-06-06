import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: AppColors.buttonText),
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: AppColors.buttonText),
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
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
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
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Functionality for sign-up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 130.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.buttonText,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: AppColors.buttonText),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Log In here!',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "-------------   or sign up with   -------------",
                style: TextStyle(color: AppColors.buttonText),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.1),
                    decoration: const BoxDecoration(
                      color: AppColors.authInput,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icon/google.png',
                        width: 37.0,
                        height: 37.0,
                      ),
                      onPressed: () {
                        // Handle Google sign-up
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(0.1),
                    decoration: const BoxDecoration(
                      color: AppColors.authInput,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icon/apple.png',
                        width: 28.0,
                        height: 28.0,
                      ),
                      onPressed: () {
                        // Handle Apple sign-up
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
