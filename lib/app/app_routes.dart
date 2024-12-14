import 'package:flutter/material.dart';
import '../models/report.dart';
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
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ItemsPage(
              initialStatus: args['status'] as String?,
              searchResults: args['searchResults'] as List<Report>?,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      case report:
        return MaterialPageRoute(builder: (_) => const ReportFormScreen());
      case details:
        // Check if arguments are passed and are of the correct type
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ItemDetails(
              itemName: args['itemName'] ?? '',
              status: args['status'] ?? '',
              description: args['description'] ?? '',
              category: args['category'] ?? '',
              location: args['location'] ?? '',
              dateTime: args['dateTime'] ?? '',
              imageUrl: args['imageUrl'] ?? '',
            ),
          );
        }
        // Fallback to a default ItemDetails if no arguments are provided
        return MaterialPageRoute(
          builder: (_) => const ItemDetails(
            itemName: "Unknown Item",
            status: "Unknown Status",
            description: "No description available",
            category: "Uncategorized",
            location: "Unknown",
            dateTime: "",
            imageUrl: "",
          ),
        );
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
