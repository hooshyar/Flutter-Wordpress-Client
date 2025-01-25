import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async'; // Add import for TimeoutException
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';
import 'dart:math';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before any platform channels
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences? prefs;
  try {
    // Initialize shared preferences with platform check
    if (!kIsWeb) {
      // Add exponential backoff retry mechanism
      int maxRetries = 3; // Reduced from 5 to 3
      int currentTry = 0;
      Duration timeout = const Duration(seconds: 3); // Reduced from 5 to 3

      while (currentTry < maxRetries) {
        try {
          prefs = await SharedPreferences.getInstance().timeout(
            timeout,
            onTimeout: () {
              throw TimeoutException(
                'SharedPreferences initialization timed out after ${timeout.inSeconds}s',
                timeout,
              );
            },
          );

          if (prefs != null) {
            debugPrint(
                'SharedPreferences initialized successfully on attempt ${currentTry + 1}');
            break;
          }
        } catch (e) {
          currentTry++;
          if (currentTry >= maxRetries) {
            debugPrint(
                'Failed to initialize SharedPreferences after $maxRetries attempts');
            break; // Don't rethrow, just break and continue without prefs
          }
          // Exponential backoff with shorter delays
          final waitTime = Duration(seconds: pow(2, currentTry).toInt());
          debugPrint(
              'Retrying SharedPreferences initialization in ${waitTime.inSeconds}s');
          await Future.delayed(waitTime);
        }
      }
    } else {
      debugPrint('Running on web platform - using alternative storage');
    }
  } catch (e) {
    // Log error but don't prevent app from starting
    debugPrint('SharedPreferences initialization failed:');
    debugPrint('Error type: ${e.runtimeType}');
    debugPrint('Error details: $e');
    debugPrint('App will continue without caching support');
  }

  // Run app with or without SharedPreferences
  runApp(App(prefs: prefs));
}
