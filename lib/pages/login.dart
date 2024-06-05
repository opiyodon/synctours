import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: const Text('Login'),
        elevation: 0.0,
      ),
      body: const Text('Login'),
    );
  }
}
