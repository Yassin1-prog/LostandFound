import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: AppColors.buttonText, // Set typed text color to white
      ),
      cursorColor: AppColors.buttonText,
      decoration: InputDecoration(
        hintText: 'Search for lost or found items...',
        hintStyle: TextStyle(color: AppColors.background2.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.search, color: AppColors.background2),
        filled: true,
        fillColor: AppColors.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
