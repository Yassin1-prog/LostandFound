import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../models/report.dart';
import '../services/user_service.dart';
import '../services/report_service.dart';
import '../app/app_theme.dart';
import 'components/navigation_bar.dart';
import './components/item_card.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final ReportService _reportService = ReportService();
  List<Report> _myReports = [];
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final user = await _userService.getUserById(currentUser.uid);
        final myReports =
            await _reportService.get2ReportsByUser(currentUser.uid);
        setState(() {
          _currentUser = user;
          _myReports = myReports;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to load user data');
    }
  }

  String _getRank(int xp) {
    if (xp >= 1000) return 'Recovery Legend';
    if (xp >= 600) return 'Master Returner';
    if (xp >= 300) return 'Expert Locator';
    if (xp >= 100) return 'Community Helper';
    return 'Novice Finder';
  }

  int _getMaxXP(int xp) {
    if (xp >= 1000) return 2000; // Can adjust this cap
    if (xp >= 600) return 1000;
    if (xp >= 300) return 600;
    if (xp >= 100) return 300;
    return 100;
  }

  Color _getRankColor(int xp) {
    if (xp >= 1000) return const Color(0xFF6C63FF); // Purple
    if (xp >= 600) return const Color(0xFF4CAF50); // Green
    if (xp >= 300) return const Color(0xFF2196F3); // Blue
    if (xp >= 100) return const Color(0xFFFFA726); // Orange
    return const Color(0xFF78909C); // Blue Grey
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await firebase_auth.FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      String title, String currentValue, Future<void> Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await onSave(controller.text);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title updated successfully')),
                  );
                } catch (e) {
                  _showErrorDialog('Failed to update $title');
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: MyNavigationBar(currentIndex: 3),
      );
    }

    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load user data')),
        bottomNavigationBar: MyNavigationBar(currentIndex: 3),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Profile Avatar with Rank Border
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _getRankColor(_currentUser!.xp),
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 45,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.person,
                                color: AppColors.buttonText,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Username and Rank
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentUser!.username,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRankColor(_currentUser!.xp)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getRankColor(_currentUser!.xp)
                                          .withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _getRank(_currentUser!.xp),
                                    style: TextStyle(
                                      color: _getRankColor(_currentUser!.xp),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // XP Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Experience Points',
                                style: TextStyle(
                                  color: AppColors.text.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${_currentUser!.xp} / ${_getMaxXP(_currentUser!.xp)} XP',
                                style: TextStyle(
                                  color: _getRankColor(_currentUser!.xp),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _currentUser!.xp /
                                  _getMaxXP(_currentUser!.xp),
                              backgroundColor: _getRankColor(_currentUser!.xp)
                                  .withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  _getRankColor(_currentUser!.xp)),
                              minHeight: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileInfoRow(
                  'Email',
                  _currentUser!.email,
                  onEdit: (newEmail) async {
                    await _userService.updateUserFields(
                        _currentUser!.id, {'email': newEmail});
                    setState(() {
                      _currentUser = _currentUser!.copyWith(email: newEmail);
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildProfileInfoRow(
                  'Phone Number',
                  _currentUser!.phoneNumber.isEmpty
                      ? 'Not set'
                      : _currentUser!.phoneNumber,
                  onEdit: (newPhone) async {
                    await _userService.updateUserFields(
                        _currentUser!.id, {'phoneNumber': newPhone});
                    setState(() {
                      _currentUser =
                          _currentUser!.copyWith(phoneNumber: newPhone);
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildProfileInfoRow(
                  'About',
                  _currentUser!.about.isEmpty
                      ? 'Tell us about yourself'
                      : _currentUser!.about,
                  onEdit: (newAbout) async {
                    await _userService.updateUserFields(
                        _currentUser!.id, {'about': newAbout});
                    setState(() {
                      _currentUser = _currentUser!.copyWith(about: newAbout);
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'My Reports',
                  onViewAll: () {
                    // Navigate to Recently Lost Items screen
                    Navigator.pushNamed(context, '/items',
                        arguments: {'source': 'user'});
                  },
                ),
                const SizedBox(height: 24),
                _buildRow(_myReports),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildProfileInfoRow(String label, String value,
      {Future<void> Function(String)? onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () =>
                _showEditDialog(label.toLowerCase(), value, onEdit),
          ),
      ],
    );
  }

  Widget _buildRow(List<Report> reports) {
    return SizedBox(
      height: 250, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _navigateToItemDetails(report),
              child: SizedBox(
                width: 200, // Fixed width for each item
                child: ItemCard(
                  imageUrl: report.imageUrl, // Placeholder for image URL
                  title: report.itemName,
                  date: DateFormat('dd/MM/yyyy').format(report.date),
                  status: report.status,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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
          size: 16, // Slightly smaller than the text for better visual balance
          color: AppColors.primary,
        ),
      ],
    ),
  );
}
