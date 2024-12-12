import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import './components/navigation_bar.dart';
import './components/search_bar.dart';
import './components/item_card.dart';

class ItemsPage extends StatelessWidget {
  final List<Map<String, String>> searchResults; // Mock data for results

  const ItemsPage({
    super.key,
    required this.searchResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: MySearchBar(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearchResults(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return GestureDetector(
          onTap: () {
            // Handle tap action (e.g., navigate to details page)
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ItemCard(
              imageUrl: result['imageUrl'] ?? 'https://via.placeholder.com/150',
              title: result['title'] ?? 'Item Name',
              date: result['date'] ?? 'dd/mm/yy',
            ),
          ),
        );
      },
    );
  }
}
