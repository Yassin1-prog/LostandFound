import 'package:flutter/material.dart';
import 'ui/welcome_screen.dart';
import 'app/app_theme.dart';
import 'app/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
