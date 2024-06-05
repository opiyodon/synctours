import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: const Text('Sign Up'),
        elevation: 0.0,
      ),
      body: const Text('Sign Up'),
    );
  }
}
