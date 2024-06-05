import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors
  static const Color secondary = Color(0xFF8E44AD); // Deep Purple for happiness
  static const Color accent = Color(0xFFFF7043); // Warm Coral for energy
  static const Color background = Color(0xFFFFCCBC); // Light Peach for warmth

  // Gradient for Loading & Auth Page Background
  static const LinearGradient loadingBackground = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFFF7043), // Warm Coral at the bottom right
      Color(0xFF8D27A7), // Deep Purple[700] at the top left
    ],
  );

  // Navbar, Icons, and Buttons
  static const Color navbarBackground = Color(0xFF8D27A7); // Deep Purple for consistency
  static const Color iconColor = Color(0xFFBA68C8); // Lighter Purple for friendly neutrality
  static const Color buttonBackground = Color(0xFFBA68C8); // Lighter Purple for a friendly 'Go'
  static const Color buttonText = Color(0xFFFFFFFF); // White for contrast

  // Text and Borders
  static const Color mainText = Color(0xFF212121); // Dark grey for readability
  static const Color secondaryText = Color(0xFF757575); // Grey for less emphasis
  static const Color textFieldBorder = Color(0xFFD1C4E9); // Light Purple for subtlety
  static const Color divider = Color(0xFFD1C4E9); // Light Purple for separation

  // Alerts and Messages
  static const Color error = Color(0xFFE57373); // Soft Red for alerts
  static const Color success = Color(0xFF81C784); // Soft Green for success message
}
