import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/wordpress_config.dart';
import 'providers/wordpress_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Main application widget
/// 
/// Provides WordPress functionality through a unified provider
/// with Material 3 design and Arabic font support
class WordPressApp extends StatelessWidget {
  const WordPressApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordPressProvider(),
      child: MaterialApp(
        // App Configuration
        title: WordPressConfig.appName,
        debugShowCheckedModeBanner: false,
        
        // Localization Support (preserved from original)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('ar', 'IQ'), // Arabic (Iraq)
          Locale('ku', 'IQ'), // Kurdish (Iraq)
        ],
        
        // Theme Configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Follow system theme
        
        // Home Screen
        home: const HomeScreen(),
        
        // Route Configuration (for future expansion)
        onGenerateRoute: _generateRoute,
      ),
    );
  }
  
  /// Generate routes for navigation
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}