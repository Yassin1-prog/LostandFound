import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../app/app_theme.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      selectedItemColor: AppColors.buttonText,
      unselectedItemColor: AppColors.buttonText.withOpacity(0.6),
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            // Navigate to Homepage
            Navigator.pushNamed(context, AppRoutes.homepage);
            break;
          case 1:
            //  Implement Messages screen navigation
            // For now, you might want to show a placeholder or snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Messages feature coming soon')),
            );
            break;
          case 2:
            // Navigate to Report Form Screen
            Navigator.pushNamed(context, AppRoutes.report);
            break;
          case 3:
            //  Implement Profile screen navigation
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
