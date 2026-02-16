import 'package:flutter/material.dart';
import 'package:news_ui_kit/features/auth/signup/signup_screen.dart';
import 'package:news_ui_kit/features/auth/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/widgets/social_button.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = true;
  String? usernameError;
  String? passwordError;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F6FA),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // void validateLogin() {
  //   setState(() {
  //     usernameError =
  //         usernameController.text.isEmpty ? "Invalid Username" : null;

  //     passwordError =
  //         passwordController.text.isEmpty ? "Password required" : null;
  //   });

  //   if (usernameError == null && passwordError == null) {
  //     debugPrint("Login Successful");
  //   }
  // }

  void validateLogin() {
    setState(() {
      /// USERNAME VALIDATION
      if (usernameController.text.isEmpty) {
       usernameError = "Username is required";
      } else if (usernameController.text.length < 4) {
       usernameError = "Username must be at least 4 characters";
      } else {
        usernameError = null;
      }

      /// PASSWORD VALIDATION
      String password = passwordController.text;

      if (password.isEmpty) {
        passwordError = "Password is required";
      } 
      else if (password.length < 8) {
        passwordError = "Password must be at least 8 characters";
      } 
      else if (!RegExp(r'[A-Z]').hasMatch(password)) {
        passwordError = "Password must contain at least 1 uppercase letter";
      } 
      else if (!RegExp(r'[0-9]').hasMatch(password)) {
        passwordError = "Password must contain at least 1 number";
      } 
      else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        passwordError = "Password must contain at least 1 special character";
      } 
      else {
        passwordError = null;
      }
    });

    if (usernameError == null && passwordError == null) {
      debugPrint("Login Successful");
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

              /// HELLO TEXT
              const Text(
                "Hello",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const Text(
                "Again!",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1877F2),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Welcome back you’ve\nbeen missed",
                style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              /// USERNAME FIELD
              AuthTextField(
                label: "Username",
                controller: usernameController,
                errorText: usernameError,
              ),

              /// PASSWORD FIELD
              AuthTextField(
                label: "Password",
                controller: passwordController,
                isPassword: true,
                errorText: passwordError,
              ),

              /// REMEMBER + FORGOT (Moved Up Slightly)
              Transform.translate(
                offset: const Offset(0, -10), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: Colors.blue,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Remember me",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot the password ?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 0),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// DIVIDER TEXT
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

              /// SOCIAL BUTTONS
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

              /// SIGN UP TEXT
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "don’t have an account ? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
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
