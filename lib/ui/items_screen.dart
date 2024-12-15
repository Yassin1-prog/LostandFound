import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../app/app_theme.dart';
import '../services/report_service.dart';
import '../models/report.dart';
import './components/navigation_bar.dart';
import './components/search_bar.dart';
import './components/item_card.dart';

class ItemsPage extends StatefulWidget {
  final String? initialStatus; // Optional parameter to specify lost or found
  final String? initialCategory; // Optional parameter to specify category
  final List<Report>? searchResults; // Optional parameter for search results

  const ItemsPage(
      {super.key,
      this.initialStatus,
      this.initialCategory,
      this.searchResults});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];
  bool _isLoading = true;
  String? _currentStatus;
  String? _currentCategory;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
    _currentCategory = widget.initialCategory;

    // If search results are provided, use them
    if (widget.searchResults != null && widget.searchResults!.isNotEmpty) {
      setState(() {
        _reports = widget.searchResults!;
        _isLoading = false;
      });
    } else {
      // Otherwise, fetch reports based on the initial status
      _fetchReports();
    }
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Report> fetchedReports;
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (_currentStatus?.toLowerCase() == 'found') {
        fetchedReports = await _reportService.getFoundReports();
      } else if (_currentStatus?.toLowerCase() == 'lost') {
        fetchedReports = await _reportService.getLostReports();
      } else if (_currentStatus?.toLowerCase() == 'user' &&
          currentUser != null) {
        fetchedReports = await _reportService.getReportsByUser(currentUser.uid);
      } else {
        fetchedReports = await _reportService.getReports();
      }

      // Apply additional category filtering if specified
      if (_currentCategory != null) {
        fetchedReports = fetchedReports
            .where((report) =>
                report.category.toLowerCase() ==
                _currentCategory!.toLowerCase())
            .toList();
      }

      setState(() {
        _reports = fetchedReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load reports: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _navigateToItemDetails(Report report) {
    Navigator.pushNamed(context, '/itemdetails', arguments: {
      'itemName': report.itemName,
      'status': report.status,
      'description': report.description,
      'category': report.category,
      'location': report.location,
      'dateTime': DateFormat('dd/MM/yyyy').format(report.date),
      'imageUrl': '', // Placeholder for image URL
    });
  }

  @override
  Widget build(BuildContext context) {
    String getTitle() {
      if (_currentStatus != null && _currentCategory != null) {
        return '${_currentStatus!.toUpperCase()} ${_currentCategory!.toUpperCase()} Items';
      } else if (_currentStatus != null) {
        return '${_currentStatus!.toUpperCase()} Items';
      } else if (_currentCategory != null) {
        return '${_currentCategory!.toUpperCase()} Items';
      }
      return 'Related Items';
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: MySearchBar(),
            ),

            // Title and Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTitle(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '${_reports.length} Items',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            // Loading or Items Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reports.isEmpty
                      ? const Center(child: Text('No items found'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            return GestureDetector(
                              onTap: () => _navigateToItemDetails(report),
                              child: ItemCard(
                                imageUrl: '', // Placeholder for image URL
                                title: report.itemName,
                                date: DateFormat('dd/MM/yyyy')
                                    .format(report.date),
                                status: report.status,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      // Navigation Bar at the bottom
      bottomNavigationBar: const MyNavigationBar(),
    );
  }
}
