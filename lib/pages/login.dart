import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
            Container(
              
              padding: const EdgeInsets.all(2.0), // Added padding
              child: Image.asset(
                'assets/icon/logo.png', 
                width: 100.0, 
                height: 100.0
              ),
            ),
            const SizedBox(height: 50.0),
            _buildTextField('Enter user name'),
            const SizedBox(height: 10.0),
            _buildTextField('Password', isPassword: true),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Login logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBackground,
                minimumSize: const Size(double.infinity, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color.fromARGB(255, 46, 2, 65),
                  fontSize: 18.0
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              child: const Text(
                'Don\'t have an account? Register here!',
                style: TextStyle(color: AppColors.buttonText),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                'or continue with', 
                style: TextStyle(
                  color: AppColors.buttonText
                  )),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
