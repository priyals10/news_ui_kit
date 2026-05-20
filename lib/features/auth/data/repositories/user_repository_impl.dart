import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart' as domain;

class UserRepositoryImpl implements domain.UserRepository {
  final FirebaseFirestore _firestore;

  // Cloudinary config
  static const String _cloudName = 'dyf2p0gaf';
  static const String _uploadPreset = 'news_ui_kit';

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Future<void> saveUserProfile(User user) async {
    // Convert to model to access toMap()
    final model = UserModel(
      uid: user.uid,
      username: user.username,
      fullName: user.fullName,
      email: user.email,
      phone: user.phone,
      country: user.country,
      photoUrl: user.photoUrl,
      bio: user.bio,
      website: user.website,
      createdAt: user.createdAt,
    );
    await _usersCollection.doc(user.uid).set(model.toMap());
  }

  @override
  Future<User?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (_) {
      try {
        final cacheDoc = await _usersCollection.doc(uid).get(const GetOptions(source: Source.cache));
        if (cacheDoc.exists && cacheDoc.data() != null) {
          return UserModel.fromMap(cacheDoc.data()!);
        }
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  @override
  Future<void> saveOrUpdateProfile(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).set(data, SetOptions(merge: true));
  }

  @override
  Future<bool> profileExists(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.exists;
  }

  @override
  Future<String> uploadProfileImage({
    required String uid,
    required String imagePath,
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    // Data layer uses XFile to handle cross-platform reading
    final imageFile = XFile(imagePath);

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['public_id'] = 'profile_$uid';

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'profile_$uid.jpg'));
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    try {
      final response = await request.send().timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        return data['secure_url'] as String;
      } else {
        throw Exception('Cloudinary upload failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException || e.toString().contains('SocketException')) {
        throw Exception('Network error: Please check your internet connection and try again.');
      }
      rethrow;
    }
  }
}
