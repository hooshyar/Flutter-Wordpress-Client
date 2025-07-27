# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter WordPress client application that fetches and displays content from WordPress sites via the REST API. The app is built for Arabic content (specifically Kurdish news site content) with bilingual support and includes caching, offline capabilities, and modern Material Design UI.

## Development Commands

### Flutter Development
```bash
# Install dependencies
flutter pub get

# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Build APK for Android
flutter build apk

# Build app bundle for Android
flutter build appbundle

# Build for iOS (requires macOS)
flutter build ios

# Run tests
flutter test

# Analyze code for issues
flutter analyze

# Format code
dart format .

# Generate code (for build_runner)
dart run build_runner build --delete-conflicting-outputs
```

### Code Quality
```bash
# Check for linting issues
flutter analyze

# Run with verbose output
flutter analyze --verbose

# Format all Dart files
dart format lib/ test/
```

## Architecture Overview

The app follows a **Provider-based state management pattern** with a layered architecture:

### Core Architecture Layers

1. **Data Layer** (`lib/src/`)
   - `client.dart` - WordPress REST API client with caching and error handling
   - `models/` - Data models (Post, Category, Media, User, Settings)
   - `db/` - Local database operations using SQLite

2. **Business Logic Layer**
   - `providers/` - State management using Provider pattern
     - `PostsProvider` - Manages post data and pagination
     - `CategoriesProvider` - Manages category data
     - `SettingsProvider` - App settings and preferences

3. **Presentation Layer**
   - `screens/` - Full-screen widgets (HomeScreen, CategoryPostsScreen, etc.)
   - `widgets/` - Reusable UI components
   - `theme/` - App theming and styling

4. **Configuration**
   - `config.dart` - WordPress site URL, API endpoints, and app constants

### Key Architectural Patterns

- **Provider Pattern**: Used for state management across the app
- **Repository Pattern**: `WordPressClient` acts as a repository for WordPress data
- **Pagination**: Infinite scroll pagination using `infinite_scroll_pagination` package
- **Caching**: SharedPreferences-based caching with configurable duration
- **Error Handling**: Comprehensive error handling with retry mechanisms

## WordPress Integration

### API Configuration
The app connects to WordPress sites via REST API. Configure in `lib/src/config.dart`:

```dart
const String baseUrl = 'https://www.ferbon.com';  // Change to your WordPress site
const String wordPressUrl = '$baseUrl/wp-json/wp/v2';
```

### Featured Categories
The app includes predefined categories for Kurdish content:
- News (176), Technology (9875), Culture (207), Health (208)
- Kurdistan (188), Iraq (6098), Woman (9102)
- Jihan (195), Abori (196)

### API Requirements
- WordPress version ≥ 4.7 (for REST API support)
- No authentication required (public content only)
- REST API must be enabled (default in modern WordPress)

## State Management Architecture

### Provider Setup
The app uses a multi-provider setup in `lib/src/app.dart`:

1. **SettingsProvider** - User preferences and app settings
2. **WordPressClient** - API client instance (provided as value)
3. **PostsProvider** - Post data with infinite scroll pagination
4. **CategoriesProvider** - Category data management

### Key Provider Features
- **PostsProvider**: Manages infinite scroll pagination with duplicate prevention
- **Async State Handling**: Proper loading states and error handling
- **Category Filtering**: Filter posts by selected categories
- **Cache Management**: Automatic caching with configurable duration

## Key Dependencies & Their Usage

### Core Dependencies
- **provider**: State management pattern
- **dio**: HTTP client with interceptors and logging
- **shared_preferences**: Local storage for caching and settings
- **sqflite**: Local SQLite database
- **infinite_scroll_pagination**: Infinite scroll lists with pagination

### UI Dependencies
- **flutter_html**: Render WordPress HTML content
- **cached_network_image**: Image caching and loading
- **shimmer**: Loading placeholders
- **pull_to_refresh**: Pull-to-refresh functionality

### Utilities
- **connectivity_plus**: Network connectivity checking
- **logger**: Logging framework
- **intl**: Internationalization support
- **timeago**: Relative time formatting

## Localization & Fonts

The app supports Arabic/Kurdish content with custom fonts:
- **NotoKufiArabic-Regular.ttf**: Arabic script support
- **NotoSansArabic-Regular.ttf**: Alternative Arabic font

Font configuration is in `pubspec.yaml` under the `fonts` section.

## Development Workflow

### Configuration Steps
1. Clone the repository
2. Run `flutter pub get`
3. Update `lib/src/config.dart` with your WordPress site URL
4. Ensure your WordPress site has REST API enabled
5. Run `flutter run` to start development

### Testing WordPress Connection
- The app will fail to load if the WordPress URL is incorrect
- Check the debug console for API request logs (enabled in debug mode)
- Verify the WordPress site returns valid JSON at `/wp-json/wp/v2/posts`

### Error Handling
The app includes comprehensive error handling:
- Network connectivity checks
- API timeout handling with exponential backoff
- SharedPreferences initialization with retry logic
- Graceful degradation when caching is unavailable

## Code Quality Standards

### Analysis Configuration
- Uses `package:flutter_lints/flutter.yaml` for linting rules
- Analysis options configured in `analysis_options.yaml`
- Run `flutter analyze` before committing changes

### Naming Conventions
- File names: snake_case (e.g., `post_details_screen.dart`)
- Class names: PascalCase (e.g., `PostDetailsScreen`)
- Variable names: camelCase (e.g., `selectedCategoryId`)
- Constants: UPPER_CASE (e.g., `DEFAULT_CACHE_DURATION`)

## Performance Considerations

### Caching Strategy
- API responses cached for 24 hours by default
- Images cached using `cached_network_image`
- Pagination prevents loading all posts at once
- Duplicate post prevention in pagination

### Memory Management
- Proper disposal of providers and controllers
- Image caching limits to prevent memory issues
- Pagination controller cleanup on provider disposal

## Common Debugging Issues

### SharedPreferences Initialization
The app includes robust SharedPreferences initialization with retry logic due to platform-specific issues. If initialization fails, the app continues without caching.

### WordPress API Issues
- Verify WordPress site URL in `config.dart`
- Check that REST API is enabled
- Ensure the site returns proper CORS headers for mobile apps
- Test API endpoints manually: `{your-site}/wp-json/wp/v2/posts`

### Network Connectivity
The app checks connectivity before making API requests and shows appropriate error messages for offline scenarios.