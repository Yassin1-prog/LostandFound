// models/report.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Report {
  final String id;
  final String userId;
  final String itemName;
  final String status;
  final String description;
  final String category;
  final String location;
  final DateTime date;
  final String imageUrl;

  Report({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.status,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    required this.imageUrl,
  });

  Report copyWith({
    String? id,
    String? userId,
    String? itemName,
    String? status,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    String? imageUrl,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemName: itemName ?? this.itemName,
      status: status ?? this.status,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itemName': itemName,
      'status': status,
      'description': description,
      'category': category,
      'location': location,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Report.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Report(
      id: doc.id, // Use the document ID directly
      userId: data['userId'] ?? '',
      itemName: data['itemName'] ?? '',
      status: data['status'] ?? 'Lost',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      date: DateTime.parse(
          data['date'] ?? DateFormat('dd/MM/yyyy').format(DateTime.now())),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
