import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';
//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:path/path.dart' as path;

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new report
  Future<void> addReport(Report report) async {
    // Create a document reference first to get the ID
    DocumentReference docRef = _firestore.collection('Report').doc();

    // Update the report with the document ID
    Report updatedReport = report.copyWith(id: docRef.id);

    // Save the report with the matching ID
    await docRef.set(updatedReport.toMap());
  }

  // Delete a report
  Future<void> deleteReport(String reportId) async {
    await _firestore.collection('Report').doc(reportId).delete();
  }

  // Get all reports for a specific user
  Future<List<Report>> getReportsByUser(String userId) async {
    QuerySnapshot query = await _firestore
        .collection('Report')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }

  // Get 2 reports for a specific user
  Future<List<Report>> get2ReportsByUser(String userId) async {
    QuerySnapshot query = await _firestore
        .collection('Report')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(2)
        .get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }

  // Get all "lost" reports, sorted by most recent
  Future<List<Report>> getLostReports() async {
    QuerySnapshot query = await _firestore
        .collection('Report')
        .where('status', isEqualTo: 'Lost')
        .orderBy('date', descending: true)
        .limit(4)
        .get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }

  // Get all "found" reports, sorted by most recent
  Future<List<Report>> getFoundReports() async {
    QuerySnapshot query = await _firestore
        .collection('Report')
        .where('status', isEqualTo: 'Found')
        .orderBy('date', descending: true)
        .limit(4)
        .get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }

  // Retrieve all reports, sorted by most recent
  Future<List<Report>> getReports() async {
    QuerySnapshot query = await _firestore
        .collection('Report')
        .orderBy('date', descending: true)
        .get();
    return query.docs.map((doc) => Report.fromDocument(doc)).toList();
  }
}
