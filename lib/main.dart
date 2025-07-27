import 'package:flutter/material.dart';

import 'app.dart';
import 'services/wordpress_service.dart';

/// Main entry point
/// 
/// Simple initialization with error handling for production readiness
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize WordPress service
  try {
    await WordPressService.instance.initialize();
  } catch (e) {
    // Continue even if initialization fails - app will handle gracefully
    debugPrint('WordPress service initialization warning: $e');
  }
  
  // Run the app
  runApp(const WordPressApp());
}