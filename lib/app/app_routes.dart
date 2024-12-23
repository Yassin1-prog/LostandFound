import 'package:flutter/material.dart';
import '../ui/welcome_screen.dart';
import '../ui/register_screen.dart';
import '../ui/login_screen.dart';
import '../ui/homepage.dart';
import '../ui/items_screen.dart';
import '../ui/report_screen.dart';
import '../ui/itemdetails.dart';
import '../ui/profile_screen.dart';
import '../ui/messages.dart';
import '../ui/chat_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String homepage = '/homepage';
  static const String items = '/items';
  static const String report = '/report';
  static const String details = '/itemdetails';
  static const String profile = '/profile';
  static const String messages = '/messages';
  static const String chat = '/chat';

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
              initialCategory: args['category'] as String?,
              searchTerm: args['searchTerm'] as String?,
              source: args['source'] as String?,
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
              userId: args['userId'] ?? '',
              reportId: args['reportId'] ?? '',
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
            userId: "",
            reportId: "",
          ),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case messages:
        return MaterialPageRoute(builder: (_) => const MessagesPage());
      case chat:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              recipientId: args['recipientId'],
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
