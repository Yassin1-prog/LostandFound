import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id; // Firebase Auth UID
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String about;
  final int xp;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.phoneNumber = '',
    this.about = '',
    this.xp = 0,
  });

// returns valid format that can be stored on firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'about': about,
      'xp': xp,
    };
  }

// when retrieving from firestore convert to data we can handle
  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      about: data['about'] ?? '',
      xp: data['xp'] ?? 0,
    );
  }
}
