import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final String photoUrl;
  final String bio;
  final String website;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    this.username = '',
    this.fullName = '',
    required this.email,
    this.phone = '',
    this.country = '',
    this.photoUrl = '',
    this.bio = '',
    this.website = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'country': country,
      'photoUrl': photoUrl,
      'bio': bio,
      'website': website,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      website: map['website'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
