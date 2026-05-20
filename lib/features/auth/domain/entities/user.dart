class User {
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

  User({
    required this.uid,
    this.username = '',
    this.fullName = '',
    required this.email,
    this.phone = '',
    this.country = '',
    this.photoUrl = '',
    this.bio = '',
    this.website = '',
    required this.createdAt,
  });
}
