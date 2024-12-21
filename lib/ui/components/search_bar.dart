import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../models/report.dart';

class MySearchBar extends StatefulWidget {
  final Function(List<Report>)? onSearchResults;

  const MySearchBar({super.key, this.onSearchResults});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  // Filter variables
  String? _selectedStatus;
  String? _selectedCategory;

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Items'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Filter
                  const Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile(
                    title: const Text('Lost'),
                    value: 'Lost',
                    groupValue: _selectedStatus,
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value),
                  ),
                  RadioListTile(
                    title: const Text('Found'),
                    value: 'Found',
                    groupValue: _selectedStatus,
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value),
                  ),
                  RadioListTile(
                    title: const Text('All'),
                    value: null,
                    groupValue: _selectedStatus,
                    onChanged: (value) =>
                        setState(() => _selectedStatus = value),
                  ),

                  // Category Filter
                  const SizedBox(height: 16),
                  const Text('Category',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile(
                    title: const Text('Electronics'),
                    value: 'electronics',
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                  RadioListTile(
                    title: const Text('Personal'),
                    value: 'personal',
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                  RadioListTile(
                    title: const Text('Documents'),
                    value: 'documents',
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                  RadioListTile(
                    title: const Text('Other'),
                    value: 'other',
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                  RadioListTile(
                    title: const Text('All'),
                    value: null,
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch();
              },
            ),
          ],
        );
      },
    );
  }

  void _performSearch() {
    // Navigate to items screen with searched terms and filters
    Navigator.pushNamed(context, '/items', arguments: {
      'searchTerm':
          _searchController.text.isEmpty ? null : _searchController.text,
      'status': _selectedStatus,
      'category': _selectedCategory,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _performSearch(),
            style: const TextStyle(
              color: AppColors.buttonText,
            ),
            cursorColor: AppColors.buttonText,
            decoration: InputDecoration(
              hintText: 'Search for lost or found items...',
              hintStyle:
                  TextStyle(color: AppColors.background2.withOpacity(0.7)),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.background2),
              filled: true,
              fillColor: AppColors.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.primary),
          onPressed: _showFilterDialog,
        ),
      ],
    );
  }
}
