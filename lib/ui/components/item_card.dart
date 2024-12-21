import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/app_theme.dart';

class ItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String status;

  const ItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      color: AppColors.background2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Ensures card takes minimum required space
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 140, // Increased height
                        width: double.infinity,
                        fit: BoxFit.cover,
                        httpHeaders: const {
                          // Add any required Appwrite headers if needed
                        },
                        placeholder: (context, url) => _buildPlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildErrorWidget(),
                      )
                    : _buildNoImageWidget(),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status.toLowerCase() == 'lost'
                        ? Colors.red.withOpacity(0.9)
                        : Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4), // Original spacing restored
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Container(
        color: Colors.grey[200],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.grey, size: 32),
            SizedBox(height: 4),
            Text(
              'Error loading image',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImageWidget() {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Container(
        color: Colors.grey[100],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              color: AppColors.primary,
              size: 32,
            ),
            SizedBox(height: 4),
            Text(
              'No image available',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
