import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  String? emailError;
  String? phoneError;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateAndSubmit() {
    setState(() {
      /// EMAIL VALIDATION
      if (emailController.text.isEmpty) {
        emailError = "Email is required";
      } else if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(emailController.text)) {
        emailError = "Enter valid email";
      } else {
        emailError = null;
      }

      /// PHONE VALIDATION
      if (phoneController.text.isEmpty) {
        phoneError = "Phone number is required";
      } else if (!RegExp(r'^[0-9]{10,13}$')
          .hasMatch(phoneController.text)) {
        phoneError = "Enter valid phone number";
      } else {
        phoneError = null;
      }
    });

    if (emailError == null && phoneError == null) {
      debugPrint("Profile Submitted");
    }
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        children: required
            ? const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                )
              ]
            : [],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      {String? errorText,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : const Color(0xFF1877F2),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Top Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Fill your Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: 30),

              /// Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1877F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _buildLabel("Username"),
              const SizedBox(height: 6),
              _buildTextField(usernameController),

              const SizedBox(height: 16),

              _buildLabel("Full Name"),
              const SizedBox(height: 6),
              _buildTextField(fullNameController),

              const SizedBox(height: 16),

              _buildLabel("Email Address", required: true),
              const SizedBox(height: 6),
              _buildTextField(
                emailController,
                errorText: emailError,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              _buildLabel("Phone Number", required: true),
              const SizedBox(height: 6),
              _buildTextField(
                phoneController,
                errorText: phoneError,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
