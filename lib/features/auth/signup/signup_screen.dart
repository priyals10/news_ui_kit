import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/features/auth/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/widgets/social_button.dart';
import 'package:news_ui_kit/features/auth/login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void validateSignup() {
    setState(() {
      if (usernameController.text.isEmpty) {
        usernameError = "Invalid Username";
      } else {
        usernameError = null;
      }

      String password = passwordController.text;

      if (password.isEmpty) {
        passwordError = "Password is required";
      } else if (password.length < 8) {
        passwordError = "At least 8 characters required";
      } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
        passwordError = "Must contain uppercase letter";
      } else if (!RegExp(r'[0-9]').hasMatch(password)) {
        passwordError = "Must contain a number";
      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        passwordError = "Must contain special character";
      } else {
        passwordError = null;
      }

      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Confirm your password";
      } else if (confirmPasswordController.text != password) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });

    if (usernameError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      debugPrint("Signup Successful");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Hello!",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1877F2),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Signup to get Started",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 50),

              AuthTextField(
                label: "Username",
                controller: usernameController,
                errorText: usernameError,
              ),

              AuthTextField(
                label: "Password",
                controller: passwordController,
                isPassword: true,
                errorText: passwordError,
              ),

              AuthTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                isPassword: true,
                errorText: confirmPasswordError,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  "or continue with",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  SocialButton(
                    text: "Facebook",
                    iconPath: "assets/icons/fb.svg",
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  SocialButton(
                    text: "Google",
                    iconPath: "assets/icons/g.svg",
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// CLICKABLE LOGIN TEXT
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account ? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Color(0xFF1877F2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              
            ],
          ),
        ),
      ),
    );
  }
}
