import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/app_theme.dart';
import '../services/report_service.dart';
import '../models/report.dart';
import './components/navigation_bar.dart';
import './components/search_bar.dart';
import './components/item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ReportService _reportService = ReportService();
  List<Report> _foundReports = [];
  List<Report> _lostReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final foundReports = await _reportService.getFoundReports();
      final lostReports = await _reportService.getLostReports();

      setState(() {
        _foundReports = foundReports;
        _lostReports = lostReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reports: $e')),
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
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MySearchBar(),
                      const SizedBox(height: 20),
                      _buildSection(
                        context,
                        title: 'Recently found items',
                        onViewAll: () {
                          Navigator.pushNamed(context, '/items',
                              arguments: {'status': 'found'});
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildGrid(_foundReports, 'Found'),
                      const SizedBox(height: 20),
                      _buildSection(
                        context,
                        title: 'Recently lost items',
                        onViewAll: () {
                          Navigator.pushNamed(context, '/items',
                              arguments: {'status': 'lost'});
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildGrid(_lostReports, 'Lost'),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required VoidCallback onViewAll}) {
    return GestureDetector(
      onTap: onViewAll,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios, // Material Design arrow icon
            size:
                16, // Slightly smaller than the text for better visual balance
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Report> reports, String status) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return GestureDetector(
          onTap: () => _navigateToItemDetails(report),
          child: ItemCard(
            imageUrl: report.imageUrl, // Placeholder for image URL
            title: report.itemName,
            date: DateFormat('dd/MM/yyyy').format(report.date),
            status: status,
          ),
        );
      },
    );
  }
}
