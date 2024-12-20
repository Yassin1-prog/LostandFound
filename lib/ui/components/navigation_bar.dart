import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../app/app_theme.dart';

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MyNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.homepage);
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Messages feature coming soon')),
        );
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.report);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: currentIndex == 2
          ? AppColors.buttonText.withOpacity(0.6) // All items unselected
          : AppColors.buttonText,
      unselectedItemColor: AppColors.buttonText.withOpacity(0.6),
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
