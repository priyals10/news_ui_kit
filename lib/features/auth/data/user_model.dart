import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final String photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    this.username = '',
    this.fullName = '',
    required this.email,
    this.phone = '',
    this.country = '',
    this.photoUrl = '',
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
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
