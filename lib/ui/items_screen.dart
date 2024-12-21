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
  final String? initialStatus;
  final String? initialCategory;
  final String? searchTerm;
  final String? source;

  const ItemsPage(
      {super.key,
      this.initialStatus,
      this.initialCategory,
      this.searchTerm,
      this.source});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];
  bool _isLoading = true;
  String? _currentStatus;
  String? _currentCategory;
  String? _currentSearchTerm;
  String? _currentSource;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
    _currentCategory = widget.initialCategory;
    _currentSearchTerm = widget.searchTerm;
    _currentSource = widget.source;

    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    List<Report> filteredReports;

    try {
      if (_currentSource == null) {
        List<Report> allReports = await _reportService.getReports();

        filteredReports = allReports.where((report) {
          bool matchesStatus = _currentStatus == null ||
              report.status.toLowerCase() == _currentStatus!.toLowerCase();

          bool matchesCategory = _currentCategory == null ||
              report.category.toLowerCase() == _currentCategory!.toLowerCase();

          bool matchesSearchTerm = _currentSearchTerm == null ||
              report.itemName
                  .toLowerCase()
                  .contains(_currentSearchTerm!.toLowerCase());

          return matchesStatus && matchesCategory && matchesSearchTerm;
        }).toList();
      } else {
        final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          filteredReports =
              await _reportService.getReportsByUser(currentUser.uid);
        } else {
          filteredReports = await _reportService.getReports();
        }
      }

      setState(() {
        _reports = filteredReports;
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
      'imageUrl': report.imageUrl, // Placeholder for image URL
      'userId': report.userId,
      'reportId': report.id,
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
      } else if (_currentSource != null) {
        return 'My reports';
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
                                imageUrl: report
                                    .imageUrl, // Placeholder for image URL
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
      bottomNavigationBar: const MyNavigationBar(currentIndex: 2),
    );
  }
}
