import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? errorText;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        /// Input Field
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),

            /// Borders
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade400,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.blue,
                width: 1.5,
              ),
            ),

            /// Error Text
            errorText: widget.errorText,

            /// Password Toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
