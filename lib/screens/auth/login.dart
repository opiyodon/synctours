import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/services/auth.dart';
import 'package:synctours/models/user.dart';
import 'package:synctours/widgets/loading.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  bool isHidden = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _login() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      CustomUser? result = await _auth.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (result == null) {
        setState(() {
          loading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to login')),
          );
        });
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        // Navigate to home screen or do something else
        navigator.pushReplacementNamed('/home');
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
                  'Login',
                  style: TextStyle(color: AppColors.buttonText),
                ),
                elevation: 0.0,
                iconTheme: const IconThemeData(
                  color: AppColors.buttonText,
                ),
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
                                        width: 100.0,
                                        height: 100.0,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
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
                                              // Add email validation if needed
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            controller: passwordController,
                                            obscureText: isHidden,
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
                                                  isHidden
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: AppColors.buttonText,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isHidden = !isHidden;
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
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: AppColors.authInputText),
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: _login,
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
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 18.0,
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
                                                "Don't have an account?",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.buttonText),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Navigate to the sign-up page
                                                  Navigator.pushNamed(
                                                      context, '/register');
                                                },
                                                child: const Text(
                                                  'Register here!',
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
