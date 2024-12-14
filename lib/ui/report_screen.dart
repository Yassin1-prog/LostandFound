import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/app_theme.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState(); // CHANGED SO IF ANY CONFLICT SEE AGAIN
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ReportService _reportService = ReportService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Form fields
  String? itemName;
  String? lostOrFound; // Dropdown value: 'Lost' or 'Found'
  String? category; // Dropdown value: 'Electronics', 'Books', 'Other'
  String? description;
  String? location;
  DateTime? date;
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Get current user's ID
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          _showErrorDialog('User not logged in');
          return;
        }

        // Create a new Report object
        final newReport = Report(
          id: FirebaseFirestore.instance
              .collection('Report')
              .doc()
              .id, // Pre-generate ID,
          userId: currentUser.uid,
          itemName: itemName!,
          status: lostOrFound!,
          description: description!,
          category: category!,
          location: location!,
          date: date!,
        );

        // Save the report to Firestore
        await _reportService.addReport(newReport);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully')),
        );

        // Navigate back or to another screen
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog('Failed to submit report: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Form'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Placeholder
                  GestureDetector(
                    onTap: () {
                      // Handle image upload
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: const Center(
                        child: Icon(Icons.image,
                            size: 48, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Item Name Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSaved: (value) => itemName = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter the item name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Lost/Found Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Lost/Found',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: lostOrFound,
                    items: ['Lost', 'Found']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => lostOrFound = value),
                    validator: (value) =>
                        value == null ? 'Please select Lost or Found' : null,
                  ),
                  const SizedBox(height: 16),

                  // Description Input (Multiline)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 4,
                    onSaved: (value) => description = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: category,
                    items: ['Electronics', 'Books', 'Other']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => category = value),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 16),

                  // Location Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      filled: true,
                      fillColor: AppColors.background,
                      suffixIcon: const Icon(Icons.location_on,
                          color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSaved: (value) => location = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a location'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Date and Time Picker
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      filled: true,
                      fillColor: AppColors.background,
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          date = selectedDate;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: date != null
                          ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'
                          : '',
                    ),
                    validator: (value) =>
                        date == null ? 'Please select a date' : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                            onPressed: _submitReport,
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: AppColors.buttonText),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
