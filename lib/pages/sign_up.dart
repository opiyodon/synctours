import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Proceed with sign-up logic
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/authentication');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Sign Up',
            style: TextStyle(color: AppColors.buttonText),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: AppColors.buttonText),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.loadingBackground,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
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
                            const SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: fullNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your full name',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your username',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      // Add more complex email validation if needed
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: phoneNumberController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your phone number',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      // Add more complex phone number validation if needed
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: isPasswordHidden,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your password',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.buttonText,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordHidden = !isPasswordHidden;
                                          });
                                        },
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters long';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: isConfirmPasswordHidden,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm your password',
                                      hintStyle: const TextStyle(
                                          color: AppColors.buttonText),
                                      filled: true,
                                      fillColor: AppColors.authInput,
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isConfirmPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.buttonText,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isConfirmPasswordHidden =
                                                !isConfirmPasswordHidden;
                                          });
                                        },
                                      ),
                                      errorStyle:
                                          const TextStyle(color: AppColors.error),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (passwordController.text != value) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        color: AppColors.authInputText),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _signUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 130.0, vertical: 10.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.buttonText,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Already have an account?",
                                        style:
                                            TextStyle(color: AppColors.buttonText),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to the sign-up page
                                          Navigator.pushNamed(context, '/login');
                                        },
                                        child: const Text(
                                          'Login here!',
                                          style: TextStyle(color: AppColors.accent),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  const Text(
                                    "-------------   or sign up with   -------------",
                                    style: TextStyle(color: AppColors.buttonText),
                                  ),
                                  const SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(1),
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
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppColors.authInput,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Image.asset(
                                            'assets/icon/apple.png',
                                            width: 35.0,
                                            height: 35.0,
                                          ),
                                          onPressed: () {
                                            // Handle Apple button tap
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
