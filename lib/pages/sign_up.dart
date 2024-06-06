import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synctours/theme/colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.loadingBackground,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 60.0),
              const SizedBox(height: 20.0),
              _buildTextField('Enter Email'),
              const SizedBox(height: 10.0),
              _buildTextField('Create Username'),
              const SizedBox(height: 10.0),
              _buildTextField('Contact Number'),
              const SizedBox(height: 10.0),
              _buildTextField('Password', isPassword: true),
              const SizedBox(height: 10.0),
              _buildTextField('Confirm Password', isPassword: true),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Sign up logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  minimumSize: const Size(double.infinity, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'or continue with', 
                style: TextStyle(
                  color: AppColors.buttonText
                  )),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook, size: 40.0),
                    onPressed: () {
                      // Facebook login logic here
                    },
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google, size: 40.0),
                    onPressed: () {
                      // Google login logic here
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'If you already have an account register here! Login here!',
                  style: TextStyle(color: Colors.purple[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
