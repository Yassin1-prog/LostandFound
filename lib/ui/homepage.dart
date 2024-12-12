import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import './components/navigation_bar.dart';
import './components/search_bar.dart';
import './components/item_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    // Navigate to Recently Found Items screen
                    Navigator.pushNamed(context, '/items');
                  },
                ),
                const SizedBox(height: 16),
                _buildGrid(),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  title: 'Recently lost items',
                  onViewAll: () {
                    // Navigate to Recently Lost Items screen
                    Navigator.pushNamed(context, '/items');
                  },
                ),
                const SizedBox(height: 16),
                _buildGrid(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(),
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
          const SizedBox(width: 8), // Small margin between title and arrow
          const Text(
            '>',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: 4, // Replace with the actual number of items
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Handle item card tap
            Navigator.pushNamed(context, '/itemdetails');
          },
          child: const ItemCard(
            imageUrl: 'https://via.placeholder.com/150',
            title: 'Item Name',
            date: 'dd/mm/yy',
          ),
        );
      },
    );
  }
}
