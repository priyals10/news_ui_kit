import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:news_ui_kit/features/auth/data/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  // Cloudinary config
  static const String _cloudName = 'dyf2p0gaf';
  static const String _uploadPreset = 'news_ui_kit';

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // ── Save User Profile ──
  Future<void> saveUserProfile(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  // ── Get User Profile ──
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // ── Update User Profile ──
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  // ── Check if profile exists ──
  Future<bool> profileExists(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.exists;
  }

  // ── Upload Profile Image (Cloudinary) ──
  Future<String> uploadProfileImage({
    required String uid,
    required File imageFile,
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['public_id'] = 'profile_$uid'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      return data['secure_url'] as String;
    } else {
      throw Exception('Cloudinary upload failed: ${response.statusCode}');
    }
  }
}
