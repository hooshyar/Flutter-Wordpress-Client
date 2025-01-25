import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences? _prefs;
  static const String _themeKey = 'theme_mode';
  static const String _perPageKey = 'posts_per_page';
  static const String _cacheTimeKey = 'cache_duration_hours';

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Posts per page
  int _postsPerPage = 10;
  int get postsPerPage => _postsPerPage;

  // Cache duration in hours
  int _cacheDurationHours = 24;
  int get cacheDurationHours => _cacheDurationHours;

  void _loadSettings() {
    if (_prefs == null) return;

    // Load theme
    final themeModeIndex = _prefs?.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];

    // Load posts per page
    _postsPerPage = _prefs?.getInt(_perPageKey) ?? 10;

    // Load cache duration
    _cacheDurationHours = _prefs?.getInt(_cacheTimeKey) ?? 24;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs?.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  Future<void> setPostsPerPage(int count) async {
    if (_postsPerPage == count) return;
    _postsPerPage = count;
    await _prefs?.setInt(_perPageKey, count);
    notifyListeners();
  }

  Future<void> setCacheDuration(int hours) async {
    if (_cacheDurationHours == hours) return;
    _cacheDurationHours = hours;
    await _prefs?.setInt(_cacheTimeKey, hours);
    notifyListeners();
  }

  Duration get cacheDuration => Duration(hours: _cacheDurationHours);
}
