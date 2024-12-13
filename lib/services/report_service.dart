// services/report_service.dart
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new report
  Future<void> addReport(Report report) async {
    await _firestore.collection('reports').add(report.toMap());
  }

  // Retrieve all reports
  Future<List<Report>> getReports() async {
    QuerySnapshot query = await _firestore.collection('reports').get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }
}
*/