import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/services/auth.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/widgets/loading.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      CustomUser? result = await _auth.registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        fullNameController.text,
        usernameController.text,
        phoneNumberController.text,
      );

      if (result == null) {
        setState(() {
          loading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to register')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        // Navigate to home screen or do something else
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : PopScope(
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
                  'Register',
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 40, 0, 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        color: AppColors.background,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      child: Image.asset(
                                        'assets/icon/icon.png',
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your full name';
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 15),
                                          TextFormField(
                                            controller: usernameController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter your username',
                                              hintStyle: const TextStyle(
                                                  color: AppColors.buttonText),
                                              filled: true,
                                              fillColor: AppColors.authInput,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your username';
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 15),
                                          TextFormField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter your email',
                                              hintStyle: const TextStyle(
                                                  color: AppColors.buttonText),
                                              filled: true,
                                              fillColor: AppColors.authInput,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your email';
                                              }
                                              // Add more complex email validation if needed
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 15),
                                          TextFormField(
                                            controller: phoneNumberController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter your phone number',
                                              hintStyle: const TextStyle(
                                                  color: AppColors.buttonText),
                                              filled: true,
                                              fillColor: AppColors.authInput,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your phone number';
                                              }
                                              // Add more complex phone number validation if needed
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 15),
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
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
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
                                                    isPasswordHidden =
                                                        !isPasswordHidden;
                                                  });
                                                },
                                              ),
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                          const SizedBox(height: 15),
                                          TextFormField(
                                            controller:
                                                confirmPasswordController,
                                            obscureText:
                                                isConfirmPasswordHidden,
                                            decoration: InputDecoration(
                                              hintText: 'Confirm your password',
                                              hintStyle: const TextStyle(
                                                  color: AppColors.buttonText),
                                              filled: true,
                                              fillColor: AppColors.authInput,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 15, 40, 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
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
                                              errorStyle: const TextStyle(
                                                  color: AppColors.error),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please confirm your password';
                                              }
                                              if (passwordController.text !=
                                                  value) {
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 130.0,
                                                      vertical: 10.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'Register',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.buttonText,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Already have an account?",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.buttonText),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                                },
                                                child: const Text(
                                                  'Login here!',
                                                  style: TextStyle(
                                                      color: AppColors.accent),
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}