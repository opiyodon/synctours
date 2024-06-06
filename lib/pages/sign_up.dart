import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Added to prevent bottom overflow
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.loadingBackground,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60.0),
            const SizedBox(height: 50.0),
            _buildTextField('Enter Email'),
            const SizedBox(height: 10.0),
            _buildTextField('Create Username'),
            const SizedBox(height: 10.0),
            _buildTextField('Contact Number'),
            const SizedBox(height: 10.0),
            _buildTextField('Password', isPassword: true),
            const SizedBox(height: 10.0),
            _buildTextField('Confirm Password', isPassword: true),
            const SizedBox(height: 30.0),
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
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 46, 2, 65), // Deep purple color
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'If you already have an account register here! Login here!',
                style: TextStyle(color: AppColors.buttonText),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                'or continue with', 
                style: TextStyle(
                  color: Color.fromARGB(255, 59, 20, 1)
                ),
              ),
            ),
            const SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.all(8.0), // Added padding
                  child: Image.asset(
                    'assets/icon/apple.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.all(8.0), // Added padding
                  child: Image.asset(
                    'assets/icon/google.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white), // Text color set to white
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // Label text color set to white
        filled: true,
        fillColor: Colors.white24, // Background color set to white24
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

