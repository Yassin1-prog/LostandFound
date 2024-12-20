import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../app/app_theme.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set initial index based on current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndexFromRoute();
    });
  }

  void _updateIndexFromRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    setState(() {
      _currentIndex = switch (currentRoute) {
        AppRoutes.homepage => 0,
        AppRoutes.report => 2,
        AppRoutes.profile => 3,
        _ => _currentIndex,
      };
    });
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return; // Prevent redundant navigation

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.homepage)
            .then((_) => _updateIndexFromRoute());
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Messages feature coming soon')),
        );
        // Reset index if we're not actually navigating
        setState(() {
          _currentIndex = _currentIndex;
        });
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.report)
            .then((_) => _updateIndexFromRoute());
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile)
            .then((_) => _updateIndexFromRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Highlight the selected tab
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
      onTap: _onItemTapped,
    );
  }
}
