import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../services/wordpress_service.dart';
import '../models/post.dart';
import '../models/category.dart' as wp;
import '../config/wordpress_config.dart';

/// Unified WordPress provider for posts and categories
class WordPressProvider with ChangeNotifier {
  final WordPressService _service = WordPressService.instance;
  
  // Pagination controller for posts
  late final PagingController<int, Post> pagingController;
  
  // State variables
  bool _isLoading = false;
  String? _error;
  List<wp.WPCategory> _categories = [];
  wp.WPCategory? _selectedCategory;
  String _searchQuery = '';
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<wp.WPCategory> get categories => _categories;
  wp.WPCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get hasError => _error != null;
  bool get hasCategories => _categories.isNotEmpty;
  
  WordPressProvider() {
    _initializePagingController();
    _initializeService();
  }
  
  /// Initialize the paging controller
  void _initializePagingController() {
    pagingController = PagingController<int, Post>(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPosts);
  }
  
  /// Initialize the WordPress service
  Future<void> _initializeService() async {
    try {
      await _service.initialize();
      await loadCategories();
    } catch (e) {
      _setError('Failed to initialize: ${e.toString()}');
    }
  }
  
  /// Fetch posts for pagination
  Future<void> _fetchPosts(int pageKey) async {
    try {
      _clearError();
      
      final response = await _service.getPosts(
        page: pageKey,
        perPage: WordPressConfig.postsPerPage,
        categories: _selectedCategory != null ? [_selectedCategory!.id] : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
      final isLastPage = !response.hasNextPage;
      
      if (isLastPage) {
        pagingController.appendLastPage(response.data);
      } else {
        pagingController.appendPage(response.data, pageKey + 1);
      }
    } catch (e) {
      _setError(e.toString());
      pagingController.error = e;
    }
  }
  
  /// Load categories from WordPress
  Future<void> loadCategories() async {
    try {
      _setLoading(true);
      _clearError();
      
      final categories = await _service.getCategories();
      
      // Filter categories with posts and sort by count
      _categories = categories
          .where((cat) => cat.hasPosts)
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Refresh posts (pull to refresh)
  Future<void> refreshPosts() async {
    _clearError();
    pagingController.refresh();
  }
  
  /// Filter posts by category
  void filterByCategory(wp.WPCategory? category) {
    if (_selectedCategory?.id != category?.id) {
      _selectedCategory = category;
      _clearSearch(); // Clear search when filtering by category
      _refreshPagination();
      notifyListeners();
    }
  }
  
  /// Search posts
  void searchPosts(String query) {
    final trimmedQuery = query.trim();
    if (_searchQuery != trimmedQuery) {
      _searchQuery = trimmedQuery;
      _clearCategoryFilter(); // Clear category filter when searching
      _refreshPagination();
      notifyListeners();
    }
  }
  
  /// Clear search
  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _clearSearch();
      _refreshPagination();
      notifyListeners();
    }
  }
  
  /// Clear category filter
  void clearCategoryFilter() {
    if (_selectedCategory != null) {
      _clearCategoryFilter();
      _refreshPagination();
      notifyListeners();
    }
  }
  
  /// Clear all filters
  void clearAllFilters() {
    bool hasFilters = _selectedCategory != null || _searchQuery.isNotEmpty;
    if (hasFilters) {
      _clearSearch();
      _clearCategoryFilter();
      _refreshPagination();
      notifyListeners();
    }
  }
  
  /// Get a single post by ID
  Future<Post?> getPost(int id) async {
    try {
      _clearError();
      return await _service.getPost(id);
    } catch (e) {
      _setError('Failed to load post: ${e.toString()}');
      return null;
    }
  }
  
  /// Get featured categories (from config)
  List<wp.WPCategory> get featuredCategories {
    return WordPressConfig.featuredCategories.values
        .map((categoryInfo) => _categories.firstWhere(
              (cat) => cat.id == categoryInfo.id,
              orElse: () => wp.WPCategory(
                id: categoryInfo.id,
                name: categoryInfo.name,
                slug: categoryInfo.slug,
              ),
            ))
        .where((cat) => cat.hasPosts)
        .toList();
  }
  
  /// Get current filter description
  String get currentFilterDescription {
    if (_selectedCategory != null && _searchQuery.isNotEmpty) {
      return 'Category: ${_selectedCategory!.name}, Search: "$_searchQuery"';
    } else if (_selectedCategory != null) {
      return 'Category: ${_selectedCategory!.name}';
    } else if (_searchQuery.isNotEmpty) {
      return 'Search: "$_searchQuery"';
    }
    return 'All Posts';
  }
  
  /// Check if any filters are active
  bool get hasActiveFilters => _selectedCategory != null || _searchQuery.isNotEmpty;
  
  /// Clear cache and reload
  Future<void> clearCacheAndReload() async {
    try {
      _setLoading(true);
      await _service.clearCache();
      await loadCategories();
      refreshPosts();
    } catch (e) {
      _setError('Failed to clear cache: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Private helper methods
  void _refreshPagination() {
    pagingController.refresh();
  }
  
  void _clearSearch() {
    _searchQuery = '';
  }
  
  void _clearCategoryFilter() {
    _selectedCategory = null;
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  @override
  void dispose() {
    pagingController.dispose();
    _service.dispose();
    super.dispose();
  }
}