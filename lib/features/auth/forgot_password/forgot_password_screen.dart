import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_ui_kit/features/auth/widgets/auth_text_field.dart';
import 'package:news_ui_kit/features/auth/otp/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError;

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

  void validateField() {
    String value = emailController.text.trim();

    setState(() {
      if (value.isEmpty) {
        emailError = "Please enter email or mobile number";
      }

      /// EMAIL VALIDATION
      else if (RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$')
          .hasMatch(value)) {
        emailError = null;
      }

      /// MOBILE VALIDATION
      else if (RegExp(r'^[0-9]{10}$').hasMatch(value)) {
        emailError = null;
      }

      else {
        emailError = "Enter a valid email or mobile number";
      }
    });

    /// If valid → navigate to OTP screen
    if (emailError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpVerificationScreen(
                contact: value,
              ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Text(
                "Forgot\nPassword ?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4E4B66),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Don’t worry! It happens. Please enter the\naddress associated with your account.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4E4B66),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              AuthTextField(
                label: "Email ID / Mobile number",
                controller: emailController,
                errorText: emailError,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateField,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
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
