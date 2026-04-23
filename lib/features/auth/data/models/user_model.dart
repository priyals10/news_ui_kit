import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    super.username = '',
    super.fullName = '',
    required super.email,
    super.phone = '',
    super.country = '',
    super.photoUrl = '',
    super.bio = '',
    super.website = '',
    required super.createdAt,
  });

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

  /// Optional: A helper to convert this model explicitly to the entity type
  /// (Though since it extends User, it usually isn't strictly needed)
  User toEntity() => this;
}
