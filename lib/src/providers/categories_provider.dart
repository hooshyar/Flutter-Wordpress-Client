import 'package:flutter/foundation.dart';
import '../client.dart';
import '../models/category.dart' as wp;

class CategoriesProvider with ChangeNotifier {
  final WordPressClient _client;

  List<wp.Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<wp.Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get error => _error;

  CategoriesProvider({
    required WordPressClient client,
  }) : _client = client {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      _categories = await _client.getCategories(
        hideEmpty: true,
        page: 1,
        perPage: 10,
      );
      _error = null;
    } catch (e) {
      _error = 'Failed to load categories: $e';
      print('Categories error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCategories() async {
    return _loadCategories();
  }

  wp.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  List<wp.Category> getCategoriesByIds(List<int> ids) {
    return _categories.where((cat) => ids.contains(cat.id)).toList();
  }

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      final categories = await _client.getCategories(
        hideEmpty: true,
        page: 1,
        perPage: 10,
      );

      if (categories.isNotEmpty) {
        _categories = categories;
        _error = null;
      } else {
        _error = 'No categories found';
      }
    } catch (e) {
      _error = 'Failed to load categories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
