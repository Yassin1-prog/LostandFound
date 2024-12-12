import 'package:flutter/material.dart';
import '../ui/welcome_screen.dart';
import '../ui/register_screen.dart';
import '../ui/login_screen.dart';
import '../ui/homepage.dart';
import '../ui/items_screen.dart';
import '../ui/report_screen.dart';
import '../ui/itemdetails.dart';
import '../ui/profile_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String homepage = '/homepage';
  static const String items = '/items';
  static const String report = '/report';
  static const String details = '/itemdetails';
  static const String profile = '/profile';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homepage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case items:
        return MaterialPageRoute(
            builder: (_) => const ItemsPage(searchResults: []));
      case report:
        return MaterialPageRoute(builder: (_) => const ReportFormScreen());
      case details:
        return MaterialPageRoute(
            builder: (_) => const ItemDetails(
                  itemName: "kgj",
                  status: "dgfdg",
                  description: "dgfdhf",
                  category: "dgfdg",
                  location: "z",
                  dateTime: "sfsdf",
                  imageUrl: "sfsdfdfv",
                ));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
