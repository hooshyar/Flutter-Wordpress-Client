# Flutter WordPress Starter Template

🚀 **The ultimate Flutter starter template for WordPress-powered apps.** Clone, configure, and deploy in under 5 minutes.

[![Flutter](https://img.shields.io/badge/Flutter-3.2+-blue.svg)](https://flutter.dev)
[![WordPress](https://img.shields.io/badge/WordPress-4.7+-blue.svg)](https://wordpress.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- 🎨 **Modern Material 3 Design** - Beautiful, responsive UI
- ⚡ **Lightning Fast Setup** - 2 commands to get started
- 🌐 **Multi-language Support** - Arabic/Kurdish fonts included
- 📱 **Cross-platform** - iOS, Android, Web ready
- 🔄 **Offline Support** - Intelligent caching system
- 🔍 **Advanced Search** - Real-time post filtering
- 📂 **Category Management** - Easy content organization
- 🔗 **Social Sharing** - Built-in share functionality
- ♿ **Accessibility First** - WCAG 2.1 AA compliant
- 🚀 **Production Ready** - Error handling, performance optimized

## 🏃‍♂️ Quick Start

### 1. Clone & Run
```bash
git clone https://github.com/hooshyar/flutter-wordpress-starter my-app
cd my-app
flutter run
```

### 2. Configure Your WordPress Site
```bash
flutter run --dart-define=WORDPRESS_URL=https://yoursite.com
```

That's it! 🎉

## 📱 Screenshots

| Home Screen | Post Detail | Categories |
|-------------|------------|------------|
| ![Home](docs/screenshots/home.png) | ![Detail](docs/screenshots/detail.png) | ![Categories](docs/screenshots/categories.png) |

## ⚙️ Configuration

### Environment Variables
Configure your app using environment variables:

```bash
# WordPress Site URL (required)
--dart-define=WORDPRESS_URL=https://yoursite.com

# App Name (optional)
--dart-define=APP_NAME="My WordPress App"

# Debug Mode (optional)
--dart-define=DEBUG=true
```

### Code Configuration
Edit `lib/config/wordpress_config.dart`:

```dart
class WordPressConfig {
  // WordPress Site Configuration
  static const String baseUrl = 'https://yoursite.com';
  
  // App Configuration
  static const String appName = 'My WordPress App';
  
  // Content Settings
  static const int postsPerPage = 10;
  static const Duration cacheValidDuration = Duration(hours: 1);
}
```

## 🏗️ Architecture

### Clean, Modular Structure
```
lib/
├── config/                 # App configuration
├── models/                 # Data models
├── providers/              # State management
├── screens/                # UI screens
├── services/               # Business logic
├── theme/                  # Material 3 theme
├── widgets/                # Reusable components
├── app.dart               # App entry point
└── main.dart              # Main function
```

### State Management
- **Provider Pattern** - Simple, reliable state management
- **Infinite Scroll** - Smooth pagination experience
- **Smart Caching** - Offline-first data strategy
- **Error Recovery** - Automatic retry mechanisms

## 🎯 Use Cases

### 📰 News & Blog Apps
Perfect for news websites, personal blogs, and content publishers.

### 🏢 Business Websites
Showcase your business content with professional design.

### 📚 Educational Content
Share knowledge and educational materials effectively.

### 🎨 Portfolio Sites
Display your work and projects beautifully.

## 🛠️ Customization

### Theming
Customize colors and typography in `lib/theme/app_theme.dart`:

```dart
class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF03DAC6);
  
  // Material 3 themes automatically generated
}
```

### Categories
Configure featured categories in `lib/config/wordpress_config.dart`:

```dart
static const Map<String, CategoryInfo> featuredCategories = {
  'Technology': CategoryInfo(id: 1, name: 'Technology', slug: 'tech'),
  'News': CategoryInfo(id: 2, name: 'News', slug: 'news'),
  // Add your categories here
};
```

### Fonts
Arabic/Kurdish fonts are pre-configured. Add custom fonts in `pubspec.yaml`:

```yaml
fonts:
  - family: YourCustomFont
    fonts:
      - asset: assets/fonts/YourFont-Regular.ttf
```

## 📦 Dependencies

**Core Dependencies** (8 total - minimal & focused):
- `provider` - State management
- `http` - Network requests  
- `cached_network_image` - Image caching
- `shared_preferences` - Local storage
- `flutter_html` - HTML rendering
- `infinite_scroll_pagination` - Pagination
- `connectivity_plus` - Network status
- `share_plus` - Social sharing

**No Complex Dependencies:**
- ❌ No SQLite database
- ❌ No Dio complexity
- ❌ No unnecessary packages
- ✅ Simple, maintainable codebase

## 🚀 Deployment

### Build for Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Environment-specific Builds
```bash
# Production
flutter build apk --dart-define=WORDPRESS_URL=https://yoursite.com

# Staging
flutter build apk --dart-define=WORDPRESS_URL=https://staging.yoursite.com
```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

### WordPress Requirements
- WordPress 4.7+ (REST API support)
- Public content (no authentication required)
- CORS enabled for mobile apps

### Test Your WordPress Site
Check if your WordPress site is compatible:
```bash
curl https://yoursite.com/wp-json/wp/v2/posts
```

## 📚 Documentation

- [📖 Setup Guide](docs/SETUP.md) - Detailed installation
- [🎨 Customization Guide](docs/CUSTOMIZATION.md) - Theming & branding  
- [🚀 Deployment Guide](docs/DEPLOYMENT.md) - App store submission
- [❓ FAQ](docs/FAQ.md) - Common questions
- [🔧 Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues

## 🤝 Contributing

We love contributions! Please see our [Contributing Guide](CONTRIBUTING.md).

### Development Setup
```bash
git clone https://github.com/hooshyar/flutter-wordpress-starter
cd flutter-wordpress-starter
flutter pub get
flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support

- ⭐ Star this repo if it helped you!
- 🐛 [Report bugs](https://github.com/hooshyar/flutter-wordpress-starter/issues)
- 💬 [Discussions](https://github.com/hooshyar/flutter-wordpress-starter/discussions)
- 📧 [Email support](mailto:support@yourcompany.com)

## 🚀 Showcase

**Built with this template?** We'd love to feature your app!

- [App Name 1](https://example.com) - Description
- [App Name 2](https://example.com) - Description
- [Add your app](https://github.com/hooshyar/flutter-wordpress-starter/issues/new?template=showcase.md)

---

<div align="center">
  <p>Made with ❤️ for the Flutter community</p>
  <p>
    <a href="https://flutter.dev">Flutter</a> •
    <a href="https://wordpress.org">WordPress</a> •
    <a href="https://material.io/design">Material Design</a>
  </p>
</div>