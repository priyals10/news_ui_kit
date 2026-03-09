import 'package:flutter/material.dart';
import 'package:news_ui_kit/core/constants/app_colors.dart';
import 'package:news_ui_kit/core/constants/app_sizes.dart';
import 'package:news_ui_kit/core/theme/app_text_styles.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool isRequired;
  final String? errorText;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isRequired = true,
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

    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        RichText(
          text: TextSpan(
            text: widget.label,
            style: AppTextStyles.label(context),
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: AppColors.error),
                    ),
                  ]
                : null,
          ),
        ),

        const SizedBox(height: AppSizes.spacingXS),

        /// Input Field
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            // Use theme defaults for fill, padding, and border
            // Override borders only when there's an error
            enabledBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(color: AppColors.error),
                  )
                : null,
            focusedBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  )
                : null,

            /// Error Text
            errorText: widget.errorText,

            /// Password Toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textGrey,
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

        const SizedBox(height: AppSizes.spacingS),
      ],
    );
  }
}
