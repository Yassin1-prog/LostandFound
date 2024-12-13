// models/report.dart
/*
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String username;
  final String itemName;
  final String status; // "lost" or "found"
  final String description;
  final String category; // e.g., "electronics", "clothing", etc.
  final String location;
  final DateTime dateTime;

  Report({
    required this.username,
    required this.itemName,
    required this.status,
    required this.description,
    required this.category,
    required this.location,
    required this.dateTime,
  });

  // Convert Report object to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'itemName': itemName,
      'status': status,
      'description': description,
      'category': category,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create a Report object from Firestore document
  factory Report.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Report(
      username: data['username'] ?? '',
      itemName: data['itemName'] ?? '',
      status: data['status'] ?? 'lost',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      dateTime:
          DateTime.parse(data['dateTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}
*/