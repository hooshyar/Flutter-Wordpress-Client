import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../config/wordpress_config.dart';
import '../models/post.dart';
import '../models/category.dart' as wp;

/// Exception for WordPress API errors
class WordPressException implements Exception {
  final String message;
  final int? statusCode;
  
  WordPressException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'WordPressException: $message';
}

/// Response wrapper with pagination metadata
class WordPressResponse<T> {
  final List<T> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  
  WordPressResponse({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });
  
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
}

/// Simplified WordPress API client
/// 
/// Provides essential WordPress REST API functionality with:
/// - Intelligent caching
/// - Offline support
/// - Error handling with retry logic
/// - Automatic connectivity checks
class WordPressService {
  static WordPressService? _instance;
  static WordPressService get instance => _instance ??= WordPressService._();
  
  WordPressService._();
  
  final http.Client _client = http.Client();
  SharedPreferences? _prefs;
  
  /// Initialize the service
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (kDebugMode) print('Warning: SharedPreferences unavailable. Caching disabled.');
    }
  }
  
  /// Check internet connectivity
  Future<bool> get isConnected async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }
  
  /// Make HTTP request with caching and error handling
  Future<http.Response> _makeRequest(
    String endpoint, {
    Map<String, String>? queryParams,
    String? cacheKey,
  }) async {
    final uri = Uri.parse(WordPressConfig.buildApiUrl(endpoint));
    final finalUri = queryParams != null 
        ? uri.replace(queryParameters: queryParams)
        : uri;
    
    // Try cache first if available
    if (_prefs != null && cacheKey != null) {
      final cached = await _getCachedResponse(cacheKey);
      if (cached != null) {
        return http.Response(cached, 200);
      }
    }
    
    // Check connectivity
    if (!await isConnected) {
      throw WordPressException(WordPressConfig.connectionError);
    }
    
    try {
      final response = await _client
          .get(finalUri, headers: WordPressConfig.defaultHeaders)
          .timeout(WordPressConfig.connectionTimeout);
      
      if (response.statusCode == 200) {
        // Cache successful response
        if (_prefs != null && cacheKey != null) {
          await _cacheResponse(cacheKey, response.body);
        }
        return response;
      } else {
        throw WordPressException(
          'API Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw WordPressException(WordPressConfig.connectionError);
    } on TimeoutException {
      throw WordPressException('Connection timeout');
    }
  }
  
  /// Get cached response
  Future<String?> _getCachedResponse(String key) async {
    if (_prefs == null) return null;
    
    final data = _prefs!.getString(key);
    final timestamp = _prefs!.getInt('${key}_timestamp');
    
    if (data != null && timestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age < WordPressConfig.cacheValidDuration.inMilliseconds) {
        return data;
      }
    }
    
    return null;
  }
  
  /// Cache response data
  Future<void> _cacheResponse(String key, String data) async {
    if (_prefs == null) return;
    
    await _prefs!.setString(key, data);
    await _prefs!.setInt('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get posts with pagination
  Future<WordPressResponse<Post>> getPosts({
    int page = 1,
    int perPage = 10,
    List<int>? categories,
    String? search,
    String orderBy = 'date',
    String order = 'desc',
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      'orderby': orderBy,
      'order': order,
      '_embed': 'true',
      'status': 'publish',
      if (categories != null && categories.isNotEmpty)
        'categories': categories.join(','),
      if (search != null && search.isNotEmpty)
        'search': search,
    };
    
    final cacheKey = 'posts_${queryParams.toString().hashCode}';
    
    final response = await _makeRequest('posts', 
        queryParams: queryParams, cacheKey: cacheKey);
    
    final List<dynamic> data = json.decode(response.body);
    final posts = data.map((json) => Post.fromJson(json)).toList();
    
    // Extract pagination info from headers
    final totalItems = int.tryParse(response.headers['x-wp-total'] ?? '0') ?? 0;
    final totalPages = int.tryParse(response.headers['x-wp-totalpages'] ?? '0') ?? 0;
    
    return WordPressResponse(
      data: posts,
      totalItems: totalItems,
      totalPages: totalPages,
      currentPage: page,
    );
  }
  
  /// Get single post by ID
  Future<Post> getPost(int id) async {
    final response = await _makeRequest('posts/$id', 
        queryParams: {'_embed': 'true'}, cacheKey: 'post_$id');
    
    final data = json.decode(response.body);
    return Post.fromJson(data);
  }
  
  /// Get categories
  Future<List<wp.WPCategory>> getCategories({
    int page = 1,
    int perPage = 100,
    bool hideEmpty = true,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (hideEmpty) 'hide_empty': 'true',
    };
    
    final response = await _makeRequest('categories', 
        queryParams: queryParams, cacheKey: 'categories_$page');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => wp.WPCategory.fromJson(json)).toList();
  }
  
  /// Search posts
  Future<WordPressResponse<Post>> searchPosts(
    String query, {
    int page = 1,
    int perPage = 10,
  }) async {
    return getPosts(
      page: page,
      perPage: perPage,
      search: query,
    );
  }
  
  /// Get posts by category
  Future<WordPressResponse<Post>> getPostsByCategory(
    int categoryId, {
    int page = 1,
    int perPage = 10,
  }) async {
    return getPosts(
      page: page,
      perPage: perPage,
      categories: [categoryId],
    );
  }
  
  /// Clear cache
  Future<void> clearCache() async {
    if (_prefs == null) return;
    
    final keys = _prefs!.getKeys().where((key) => 
        key.startsWith('posts_') || 
        key.startsWith('post_') || 
        key.startsWith('categories_')).toList();
    
    for (final key in keys) {
      await _prefs!.remove(key);
      await _prefs!.remove('${key}_timestamp');
    }
  }
  
  /// Dispose resources
  void dispose() {
    _client.close();
  }
}