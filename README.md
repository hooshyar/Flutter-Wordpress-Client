# Flutter WordPress Client

A Flutter client for WordPress sites that doesn't require authentication. Perfect for building mobile apps for WordPress-based blogs and news sites.

## 🎉 NEW: Modernized Version Available!

We've created a **completely modernized version** of this WordPress client with significant improvements:

**📍 Switch to the modernized branch:**
```bash
git checkout modernized-wordpress-client
```

### Why Use the Modernized Version?

| **Original (master)** | **Modernized (modernized-wordpress-client)** |
|----------------------|---------------------------------------------|
| 37 files, 4,487 lines | 15 files, ~1,500 lines |
| 16 dependencies | 8 core dependencies |
| SQLite database | SharedPreferences caching |
| Complex setup (30+ min) | Quick setup (2 minutes) |
| Multiple providers | Unified provider |
| Legacy patterns | Modern Flutter patterns |

### Modernized Features:
- ✨ **Material 3 Design** - Clean, modern UI
- 🔍 **Real-time Search** - Instant search with infinite scroll
- 📱 **Responsive Design** - Perfect on all screen sizes
- 🌍 **Arabic/Kurdish Support** - Built-in font support
- ⚡ **Performance Optimized** - Faster loading and smoother scrolling
- 🧪 **Fully Tested** - Comprehensive test coverage
- 🚀 **Production Ready** - Environment-based configuration

**🎯 Perfect for**: Anyone who wants a simple, modern WordPress client without complexity.

---

## Original Implementation (Current Branch)

## Features

- 📱 Clean, Material Design UI
- 🚀 Fast and responsive
- 📄 View posts and categories
- 🖼️ Media support
- 🔍 Search functionality
- 🌐 No authentication required

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.0)
- Dart SDK (>=3.2.0)
- A WordPress site with REST API enabled

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Flutter-Wordpress-Client.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update the WordPress site URL in `lib/src/config.dart`

4. Run the app:
```bash
flutter run
```

## Configuration

Edit `lib/src/config.dart` to set your WordPress site URL and other configurations:

```dart
final String wordPressUrl = 'https://your-wordpress-site.com';
```

## Architecture

The app follows a clean architecture pattern:
- `/models` - Data models
- `/widgets` - Reusable UI components
- `/db` - Local database handling
- `/view_models` - Business logic

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

<p>
<img src="https://www.datacode.app/flutter-wp/wp-content/uploads/2020/01/wordpress_flutter1.gif" alt="gif 1 title="Wordpress-client" />
<img src="https://www.datacode.app/flutter-wp/wp-content/uploads/2020/01/wordpress_flutter2.gif" alt="image 2" title="Wordpress-client" />
</p>
for more information about WordPress rest API visit https://developer.wordpress.org/rest-api/ 

For help getting started with Flutter, view Flutter online
[documentation](https://flutter.io/).

I have used this repository:
https://github.com/kbirch/wordpress_client

## Prerequisites

Flutter

Make sure your WordPress version is greater or equal to 4.7

Clone repository
<code>git clone https://github.com/hooshyar/Flutter-Wordpress-Client.git </code>

and open <code>pubspec.yaml</code>

run 
<code>flutter packages get</code>

open config.dart and change <code>"https://www.mihrabani.com"</code> to your website address for example if my website is wordpress.com you have to change it to this : <code>"http://www.wordpress.com"</code>
Do not add any additional characters like "/".

to your WordPress website address

run app on a simulator
<code>flutter run</code>

## Roadmap
- [x] Sliver app bar
- [x] Sliver list view
- [x] Connectivity status, if offline pop a message
- [ ] Cache on device
- [x] Pull to refresh
- [x] Global perPage
- [ ] Global theming
- [ ] Setting page
- [x] Provider
- [ ] Splash screen 
- [ ] Nice Categories page screen 
- [ ] real time clap button like Medium
- [ ] Share and fav buttons

---

## 🚀 Quick Start Guide

### For Modern, Simple Setup (Recommended):
```bash
git clone https://github.com/hooshyar/Flutter-Wordpress-Client.git
cd Flutter-Wordpress-Client
git checkout modernized-wordpress-client
```
**Setup time**: ~2 minutes | **Best for**: New projects, production apps

### For Original Implementation:
```bash
git clone https://github.com/hooshyar/Flutter-Wordpress-Client.git
cd Flutter-Wordpress-Client
# Stay on master branch
```
**Setup time**: ~30 minutes | **Best for**: Learning, customization, legacy support

---

## 📋 Branch Comparison

| Feature | Master Branch | Modernized Branch |
|---------|--------------|-------------------|
| **Architecture** | Complex, 37 files | Simple, 15 files |
| **Dependencies** | 16 packages | 8 packages |
| **Database** | SQLite | SharedPreferences |
| **State Management** | 3 separate providers | 1 unified provider |
| **UI Design** | Custom Material | Material 3 |
| **Setup Complexity** | High | Low |
| **Maintenance** | High | Low |
| **Performance** | Good | Optimized |
| **Testing** | Basic | Comprehensive |
| **Documentation** | Basic | Detailed |

**💡 Recommendation**: Use the **modernized branch** for new projects. It's production-ready, well-tested, and much easier to customize. 
