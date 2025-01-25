import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'client.dart';
import 'config.dart';
import 'providers/posts_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  final SharedPreferences? prefs;
  late final WordPressClient wordPressClient;

  App({Key? key, this.prefs}) : super(key: key) {
    wordPressClient = WordPressClient(
      baseUrl: baseUrl,
      prefs: prefs,
      cacheValidDuration: defaultCacheDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(prefs),
        ),
        Provider<WordPressClient>.value(value: wordPressClient),
        ChangeNotifierProvider(
          create: (context) => PostsProvider(
            client: context.read<WordPressClient>(),
            settings: context.read<SettingsProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(
            client: context.read<WordPressClient>(),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          title: 'WordPress Blog',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
