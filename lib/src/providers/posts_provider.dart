import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../client.dart';
import '../models/post.dart';
import 'settings_provider.dart';

class PostsProvider with ChangeNotifier {
  final WordPressClient _client;
  final SettingsProvider _settings;
  late final PagingController<int, Post> pagingController;

  bool _isLoading = false;
  String? _error;
  final Set<int> _loadedPostIds = {};
  int? _selectedCategoryId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  PostsProvider({
    required WordPressClient client,
    required SettingsProvider settings,
  })  : _client = client,
        _settings = settings {
    pagingController = PagingController<int, Post>(firstPageKey: 1)
      ..addPageRequestListener((pageKey) {
        // Use Future.microtask to avoid state changes during build
        Future.microtask(() => _fetchPage(pageKey));
      });
  }

  Future<void> _fetchPage(int pageKey) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      // Don't notify here to avoid build-time changes

      final filters = PostFilters(
        categoryIds:
            _selectedCategoryId != null ? [_selectedCategoryId!] : null,
        orderBy: PostOrdering.date,
        order: OrderDirection.desc,
        embed: true,
      );

      final response = await _client.getPosts(
        filters: filters,
        page: pageKey,
        perPage: _settings.postsPerPage,
      );

      // Process posts and filter duplicates
      final newPosts = response.items.where((post) {
        if (_loadedPostIds.contains(post.id)) return false;
        _loadedPostIds.add(post.id);
        return true;
      }).toList();

      final isLastPage = newPosts.length < _settings.postsPerPage;

      // Update error state before modifying the controller
      _error = null;

      if (!pagingController.hasListeners) return;

      if (isLastPage || newPosts.isEmpty) {
        pagingController.appendLastPage(newPosts);
      } else {
        pagingController.appendPage(newPosts, pageKey + 1);
      }
    } catch (e) {
      _error = e.toString();
      if (pagingController.hasListeners) {
        pagingController.error = e;
      }
    } finally {
      _isLoading = false;
      // Notify after all state changes are complete
      notifyListeners();
    }
  }

  void filterByCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    refreshPosts();
  }

  Future<void> refreshPosts() async {
    _loadedPostIds.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();

    if (pagingController.hasListeners) {
      pagingController.refresh();
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
