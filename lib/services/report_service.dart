import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new report
  Future<void> addReport(Report report) async {
    await _firestore.collection('Report').add(report.toMap());
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
