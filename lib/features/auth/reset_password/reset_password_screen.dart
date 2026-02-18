import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/features/auth/success/reset_success_screen.dart';
import 'package:news_ui_kit/features/auth/widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController newPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? newPasswordError;
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

  void validateAndSubmit() {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword =
        confirmPasswordController.text.trim();

    setState(() {
      /// NEW PASSWORD VALIDATION
      if (newPassword.isEmpty) {
        newPasswordError = "Password is required";
      } else if (newPassword.length < 8) {
        newPasswordError = "Must be at least 8 characters";
      } else if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
        newPasswordError = "Must contain uppercase letter";
      } else if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
        newPasswordError = "Must contain a number";
      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
          .hasMatch(newPassword)) {
        newPasswordError = "Must contain special character";
      } else {
        newPasswordError = null;
      }

      /// CONFIRM PASSWORD VALIDATION
      if (confirmPassword.isEmpty) {
        confirmPasswordError =
            "Please confirm your password";
      } else if (confirmPassword != newPassword) {
        confirmPasswordError =
            "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });

    if (newPasswordError == null &&
    confirmPasswordError == null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ResetSuccessScreen(),
        ),
      );
    }
  }
  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Reset\nPassword",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4E4B66),
                ),
              ),

              const SizedBox(height: 30),

              AuthTextField(
                label: "New Password",
                controller: newPasswordController,
                isPassword: true,
                errorText: newPasswordError,
              ),

              AuthTextField(
                label: "Confirm new password",
                controller:
                    confirmPasswordController,
                isPassword: true,
                errorText: confirmPasswordError,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1877F2),
                    padding:
                        const EdgeInsets.symmetric(
                            vertical: 18),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
