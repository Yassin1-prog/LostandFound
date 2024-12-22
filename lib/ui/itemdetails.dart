import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/user_service.dart';
import '../app/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/report_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../ui/chat_screen.dart';
import 'package:vibration/vibration.dart';

class ItemDetails extends StatefulWidget {
  final String itemName;
  final String status; // "Lost" or "Found"
  final String description;
  final String category;
  final String location;
  final String dateTime;
  final String imageUrl;
  final String userId;
  final String reportId;

  const ItemDetails({
    super.key,
    required this.itemName,
    required this.status,
    required this.description,
    required this.category,
    required this.location,
    required this.dateTime,
    required this.imageUrl,
    required this.userId,
    required this.reportId,
  });

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final UserService _userService = UserService();
  final ReportService _reportService = ReportService();
  bool _isLoading = false;
  String? currentUserId = firebase_auth.FirebaseAuth.instance.currentUser?.uid;

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteReport();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteReport() async {
    setState(() => _isLoading = true);
    try {
      await _reportService.deleteReport(widget.reportId);
      if (!mounted) return;
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 100, 50, 100]); // Two quick pulses
        // Pattern explanation: [wait 0ms, vibrate 50ms, wait 50ms, vibrate 50ms]
      }
      // Navigate to profile page
      Navigator.of(context)
          .pushReplacementNamed('/profile'); // Adjust route name as needed

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting report: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _makePhoneCall() async {
    setState(() => _isLoading = true);

    try {
      final user = await _userService.getUserById(widget.userId);

      if (user == null || user.phoneNumber.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number not available'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: user.phoneNumber,
      );

      if (!await launchUrl(phoneUri)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone app'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper function to build details rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
          const Divider(color: AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (currentUserId == widget.userId) {
      // Show delete button for report owner
      return Center(
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _showDeleteConfirmation,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.delete),
          label: Text(_isLoading ? 'Deleting...' : 'Delete Report'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      );
    } else {
      // Show call and message buttons for other users
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _makePhoneCall,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.call),
            label: Text(_isLoading ? 'Loading...' : 'Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(recipientId: widget.userId),
                ),
              );
            },
            icon: const Icon(Icons.message),
            label: const Text('Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.background2,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          color: AppColors.background,
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
                ),
                const SizedBox(height: 16),

                // Item Details
                _buildDetailRow('Item Name', widget.itemName),
                _buildDetailRow('Status', widget.status),
                _buildDetailRow('Description', widget.description),
                _buildDetailRow('Category', widget.category),
                _buildDetailRow('Location', widget.location),
                _buildDetailRow('Date', widget.dateTime),

                const SizedBox(height: 32),

                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
