import 'package:flutter/material.dart';
import 'ui/welcome_screen.dart';
import 'app/app_theme.dart';
import 'app/app_routes.dart';

void main() {
  runApp(const LostAndFoundApp());
}

class LostAndFoundApp extends StatelessWidget {
  const LostAndFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.welcome,
      debugShowCheckedModeBanner: false,
    );
  }
}
