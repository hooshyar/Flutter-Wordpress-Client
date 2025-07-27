/// WordPress Configuration
/// 
/// Simple, environment-aware configuration for WordPress integration.
/// Supports development, staging, and production environments.
class WordPressConfig {
  // WordPress Site Configuration
  static const String baseUrl = String.fromEnvironment(
    'WORDPRESS_URL',
    defaultValue: 'https://www.ferbon.com', // Kurdish news site
  );
  
  // API Configuration
  static const String apiVersion = 'wp/v2';
  static String get apiUrl => '$baseUrl/wp-json/$apiVersion';
  
  // App Configuration
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Flutter WordPress',
  );
  
  static const String appVersion = '2.0.0';
  
  // Content Configuration
  static const int postsPerPage = 10;
  static const Duration cacheValidDuration = Duration(hours: 1);
  static const Duration connectionTimeout = Duration(seconds: 30);
  
  // Featured Categories (preserved from original)
  static const Map<String, CategoryInfo> featuredCategories = {
    'News': CategoryInfo(id: 176, name: 'News', slug: 'news'),
    'Technology': CategoryInfo(id: 9875, name: 'Technology', slug: 'technology'),
    'Culture': CategoryInfo(id: 207, name: 'Culture', slug: 'culture'),
    'Health': CategoryInfo(id: 208, name: 'Health', slug: 'health'),
    'Kurdistan': CategoryInfo(id: 188, name: 'Kurdistan', slug: 'kurdistan'),
    'Iraq': CategoryInfo(id: 6098, name: 'Iraq', slug: 'iraq'),
    'Woman': CategoryInfo(id: 9102, name: 'Woman', slug: 'woman'),
    'Jihan': CategoryInfo(id: 195, name: 'Jihan', slug: 'jihan'),
    'Abori': CategoryInfo(id: 196, name: 'Abori', slug: 'abori'),
  };
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;
  static const double defaultRadius = 12.0;
  
  // Error Messages (multilingual support preserved)
  static const String connectionError = 'خەتای پەیوەندی ئینتەرنێت';
  static const String serverError = 'خەتای ڕاژەکار';
  static const String noPostsError = 'هیچ پۆستێک نەدۆزرایەوە';
  
  // Development/Debug Configuration
  static const bool isDebugMode = bool.fromEnvironment('DEBUG', defaultValue: false);
  static const bool enableDetailedLogging = isDebugMode;
  
  // Validation
  static bool get isValidConfiguration {
    return baseUrl.isNotEmpty && 
           baseUrl.startsWith('http') &&
           appName.isNotEmpty;
  }
  
  // Helper Methods
  static String buildApiUrl(String endpoint) {
    return '$apiUrl/$endpoint';
  }
  
  static Map<String, String> get defaultHeaders => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'User-Agent': '$appName/$appVersion Flutter WordPress Client',
  };
}

/// Category information model
class CategoryInfo {
  final int id;
  final String name;
  final String slug;
  
  const CategoryInfo({
    required this.id,
    required this.name,
    required this.slug,
  });
  
  @override
  String toString() => 'CategoryInfo(id: $id, name: $name, slug: $slug)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryInfo &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}