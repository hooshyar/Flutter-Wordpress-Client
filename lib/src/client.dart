import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpException;

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart' hide Logger;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

import 'models/category.dart' as wp_category;
import 'models/media.dart';
import 'models/post.dart';
import 'models/users.dart';
import 'config.dart';

/// Custom exception for WordPress API errors
class WordPressException implements Exception {
  final String message;
  final int? statusCode;

  WordPressException(this.message, [this.statusCode]);

  @override
  String toString() => 'WordPressException: $message ${statusCode ?? ""}';
}

/// Response metadata from WordPress API
class WPResponse<T> {
  final List<T> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  WPResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });
}

/// Post ordering options
class PostOrdering {
  static const String date = 'date';
  static const String relevance = 'relevance';
  static const String id = 'id';
  static const String include = 'include';
  static const String title = 'title';
  static const String slug = 'slug';
  static const String modifiedDate = 'modified';
  static const String menuOrder = 'menu_order';
  static const String commentCount = 'comment_count';
}

/// Order direction options
class OrderDirection {
  static const String asc = 'asc';
  static const String desc = 'desc';
}

/// Date filtering options for posts
class DateQuery {
  final DateTime? after;
  final DateTime? before;
  final bool inclusive;

  DateQuery({
    this.after,
    this.before,
    this.inclusive = false,
  });

  Map<String, String> toQueryParams() {
    return {
      if (after != null) 'after': after!.toIso8601String(),
      if (before != null) 'before': before!.toIso8601String(),
      if (inclusive) 'inclusive': 'true',
    };
  }
}

/// Advanced filtering options for posts
class PostFilters {
  final List<int>? categoryIds;
  final List<int>? tagIds;
  final List<int>? authorIds;
  final List<int>? excludeIds;
  final List<int>? includeIds;
  final List<String>? slugs;
  final DateQuery? dateQuery;
  final bool? sticky;
  final String? search;
  final String orderBy;
  final String order;
  final bool embed;

  PostFilters({
    this.categoryIds,
    this.tagIds,
    this.authorIds,
    this.excludeIds,
    this.includeIds,
    this.slugs,
    this.dateQuery,
    this.sticky,
    this.search,
    this.orderBy = PostOrdering.date,
    this.order = OrderDirection.desc,
    this.embed = true,
  });

  Map<String, String> toQueryParams() {
    return {
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
      if (embed) '_embed': 'true',
      if (search != null) 'search': search!,
      if (categoryIds?.isNotEmpty ?? false)
        'categories': categoryIds!.join(','),
      if (tagIds?.isNotEmpty ?? false) 'tags': tagIds!.join(','),
      if (authorIds?.isNotEmpty ?? false) 'author': authorIds!.join(','),
      if (excludeIds?.isNotEmpty ?? false) 'exclude': excludeIds!.join(','),
      if (includeIds?.isNotEmpty ?? false) 'include': includeIds!.join(','),
      if (slugs?.isNotEmpty ?? false) 'slug': slugs!.join(','),
      if (sticky != null) 'sticky': sticky.toString(),
      ...?dateQuery?.toQueryParams(),
    };
  }
}

/// Media filtering options
class MediaFilters {
  final List<int>? ids;
  final List<int>? excludeIds;
  final List<int>? parentIds;
  final List<String>? mimeTypes;
  final MediaType? mediaType;
  final String orderBy;
  final String order;

  MediaFilters({
    this.ids,
    this.excludeIds,
    this.parentIds,
    this.mimeTypes,
    this.mediaType,
    this.orderBy = PostOrdering.date,
    this.order = OrderDirection.desc,
  });

  Map<String, String> toQueryParams() {
    return {
      'orderby': orderBy,
      'order': order,
      if (ids?.isNotEmpty ?? false) 'include': ids!.join(','),
      if (excludeIds?.isNotEmpty ?? false) 'exclude': excludeIds!.join(','),
      if (parentIds?.isNotEmpty ?? false) 'parent': parentIds!.join(','),
      if (mimeTypes?.isNotEmpty ?? false) 'mime_type': mimeTypes!.join(','),
      if (mediaType != null) 'media_type': mediaType!.name,
    };
  }
}

/// Media types supported by WordPress
enum MediaType {
  image,
  video,
  audio,
  application;

  String get name => toString().split('.').last;
}

/// WordPress API Client with caching and offline support
class WordPressClient {
  final Dio _dio;
  final Logger _logger;
  final SharedPreferences? _prefs;
  final Duration _cacheValidDuration;

  WordPressClient({
    required String baseUrl,
    SharedPreferences? prefs,
    Duration? cacheValidDuration,
  })  : _dio = Dio(BaseOptions(
          baseUrl: baseUrl.endsWith('/')
              ? '${baseUrl}wp-json/wp/v2'
              : '$baseUrl/wp-json/wp/v2',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        )),
        _logger = Logger('WordPressClient'),
        _prefs = prefs,
        _cacheValidDuration = cacheValidDuration ?? const Duration(hours: 1) {
    // Only add logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
  }

  /// Check if device is online
  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Generic API request with optional caching
  Future<T> _request<T>({
    required String path,
    required T Function(dynamic data) parser,
    Map<String, dynamic>? queryParameters,
    String? cacheKey,
  }) async {
    try {
      // Check cache if prefs is available
      if (_prefs != null && cacheKey != null) {
        final cachedData = _prefs!.getString(cacheKey);
        if (cachedData != null) {
          final cacheTime = _prefs!.getInt('${cacheKey}_time');
          if (cacheTime != null &&
              DateTime.now().millisecondsSinceEpoch - cacheTime <
                  _cacheValidDuration.inMilliseconds) {
            return parser(json.decode(cachedData));
          }
        }
      }

      // Check connectivity
      if (!await _isOnline()) {
        throw WordPressException('No internet connection');
      }

      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );

      // Cache the response if prefs is available
      if (_prefs != null && cacheKey != null) {
        await _prefs!.setString(cacheKey, json.encode(response.data));
        await _prefs!
            .setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
      }

      return parser(response.data);
    } on DioException catch (e) {
      _logger.severe('API Error: ${e.message}', e, e.stackTrace);
      throw WordPressException(
        e.message ?? 'Unknown error occurred',
        e.response?.statusCode,
      );
    }
  }

  /// Handles API response and error cases
  Future<T> _handleResponse<T>(
    String endpoint,
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) parser,
  ) async {
    try {
      final response = await request();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        return parser(response.data);
      }

      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        response: response,
        message: 'API request failed: $statusCode',
      );
    } catch (e) {
      _logger.severe('Error accessing $endpoint: $e');
      rethrow;
    }
  }

  /// Handles API response and error cases with pagination metadata
  Future<WPResponse<T>> _handlePaginatedResponse<T>(
    String endpoint,
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) parser,
  ) async {
    try {
      final response = await request();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final items =
            (response.data as List).map((item) => parser(item)).toList();

        final headers = response.headers.map;
        return WPResponse(
          items: items,
          totalItems: int.parse(headers['x-wp-total']?.first ?? '0'),
          totalPages: int.parse(headers['x-wp-totalpages']?.first ?? '0'),
          currentPage: int.parse(headers['x-wp-page']?.first ?? '1'),
        );
      }

      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        response: response,
        message: 'API request failed: $statusCode',
      );
    } catch (e) {
      _logger.severe('Error accessing $endpoint: $e');
      rethrow;
    }
  }

  /// Get public posts with advanced filtering
  Future<WPResponse<Post>> getPosts({
    PostFilters? filters,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'publish',
      ...(filters ?? PostFilters()).toQueryParams(),
    };

    final endpoint = '/$postsEndpoint${_buildQueryString(queryParams)}';

    return _handlePaginatedResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => Post.fromMap(json as Map<String, dynamic>),
    );
  }

  /// Get a single published post by ID
  Future<Post?> getPostById(int postId, {bool embed = true}) async {
    final queryParams = <String, String>{
      'status': 'publish',
      if (embed) '_embed': 'true',
    };

    final endpoint = '/wp/v2/posts/$postId${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => Post.fromMap(json as Map<String, dynamic>),
    );
  }

  /// Get published posts by slug
  Future<List<Post>> getPostsBySlug(String slug, {bool embed = true}) async {
    final queryParams = <String, String>{
      'slug': slug,
      'status': 'publish',
      if (embed) '_embed': 'true',
    };

    final endpoint = '/wp/v2/posts${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => (json as List)
          .map((map) => Post.fromMap(map as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get published posts by category, tag, or custom taxonomy
  Future<List<Post>> getPostsByTaxonomy({
    required String taxonomyType,
    required List<int> termIds,
    String orderBy = 'date',
    String order = 'desc',
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final String taxQuery = taxonomyType == 'category'
        ? 'categories'
        : taxonomyType == 'post_tag'
            ? 'tags'
            : taxonomyType;

    final queryParams = <String, String>{
      taxQuery: termIds.join(','),
      'status': 'publish',
      'per_page': perPage.toString(),
      'page': page.toString(),
      if (embed) '_embed': 'true',
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
    };

    final endpoint = '/wp/v2/posts${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => (json as List)
          .map((map) => Post.fromMap(map as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get sticky (featured) posts
  Future<List<Post>> getStickyPosts({bool embed = true}) async {
    final queryParams = <String, String>{
      'sticky': 'true',
      'status': 'publish',
      if (embed) '_embed': 'true',
    };

    final endpoint = '/wp/v2/posts${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => (json as List)
          .map((map) => Post.fromMap(map as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get all public categories
  Future<List<wp_category.Category>> getCategories({
    bool hideEmpty = true,
    List<int>? excludeIds,
    String? search,
    int? parent,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      if (hideEmpty) 'hide_empty': 'true',
      if (excludeIds?.isNotEmpty ?? false) 'exclude': excludeIds!.join(','),
      if (search != null) 'search': search,
      if (parent != null) 'parent': parent.toString(),
    };

    final endpoint = '/categories${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => (json as List)
          .map((map) =>
              wp_category.Category.fromMap(map as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get all public tags
  Future<List<dynamic>> getTags({
    bool hideEmpty = true,
    List<int>? excludeIds,
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      if (hideEmpty) 'hide_empty': 'true',
      if (excludeIds?.isNotEmpty ?? false) 'exclude': excludeIds!.join(','),
      if (search != null) 'search': search,
    };

    final endpoint = '/wp/v2/tags${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as List,
    );
  }

  /// Get public media items
  Future<List<Media>> getMedia({
    MediaFilters? filters,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      ...(filters ?? MediaFilters()).toQueryParams(),
    };

    final endpoint = '/wp/v2/media${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => (json as List)
          .map((map) => Media.fromMap(map as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get public author information
  Future<User?> getAuthor(int authorId) async {
    final endpoint = '/wp/v2/users/$authorId';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => User.fromMap(json as Map<String, dynamic>),
    );
  }

  /// Helper method to build query strings
  String _buildQueryString(Map<String, String> params) {
    if (params.isEmpty) return '';

    return '?' +
        params.entries
            .map((e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
  }

  /// Get public pages
  Future<WPResponse<Post>> getPages({
    List<int>? parentIds,
    String? search,
    String orderBy = 'menu_order',
    String order = 'asc',
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'publish',
      if (embed) '_embed': 'true',
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
      if (search != null) 'search': search,
      if (parentIds?.isNotEmpty ?? false) 'parent': parentIds!.join(','),
    };

    final endpoint = '/wp/v2/pages${_buildQueryString(queryParams)}';

    return _handlePaginatedResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => Post.fromMap(json as Map<String, dynamic>),
    );
  }

  /// Get public custom post types
  Future<List<dynamic>> getPostTypes({bool embed = true}) async {
    final queryParams = embed ? {'_embed': 'true'} : null;
    final endpoint = '/wp/v2/types${_buildQueryString(queryParams ?? {})}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json is Map ? json.values.toList() : json as List,
    );
  }

  /// Get posts from a specific custom post type
  Future<WPResponse<Post>> getCustomPosts(
    String postType, {
    String? search,
    String orderBy = 'date',
    String order = 'desc',
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'publish',
      if (embed) '_embed': 'true',
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
      if (search != null) 'search': search,
    };

    final endpoint = '/wp/v2/$postType${_buildQueryString(queryParams)}';

    return _handlePaginatedResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => Post.fromMap(json as Map<String, dynamic>),
    );
  }

  /// Get site settings and information
  Future<Map<String, dynamic>> getSiteInfo() async {
    const endpoint = '/wp/v2/settings';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as Map<String, dynamic>,
    );
  }

  /// Search across all content types
  Future<Map<String, dynamic>> search(
    String query, {
    String? type,
    String? subtype,
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'search': query,
      'per_page': perPage.toString(),
      'page': page.toString(),
      if (embed) '_embed': 'true',
      if (type != null) 'type': type,
      if (subtype != null) 'subtype': subtype,
    };

    final endpoint = '/wp/v2/search${_buildQueryString(queryParams)}';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as Map<String, dynamic>,
    );
  }

  /// Get public comments for a post
  Future<WPResponse<dynamic>> getComments(
    int postId, {
    String orderBy = 'date',
    String order = 'desc',
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'post': postId.toString(),
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'approve',
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
    };

    final endpoint = '/wp/v2/comments${_buildQueryString(queryParams)}';

    return _handlePaginatedResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json,
    );
  }

  /// Get menu locations
  Future<Map<String, dynamic>> getMenuLocations() async {
    const endpoint = '/wp-api-menus/v2/menu-locations';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as Map<String, dynamic>,
    );
  }

  /// Get menu by location
  Future<dynamic> getMenuByLocation(String location) async {
    final endpoint = '/wp-api-menus/v2/menu-locations/$location';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json,
    );
  }

  /// Get block patterns
  Future<List<dynamic>> getBlockPatterns() async {
    const endpoint = '/wp/v2/block-patterns/patterns';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as List,
    );
  }

  /// Get block pattern categories
  Future<List<dynamic>> getBlockPatternCategories() async {
    const endpoint = '/wp/v2/block-patterns/categories';

    return _handleResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => json as List,
    );
  }

  /// Cleanup resources
  void dispose() {
    _dio.close();
  }

  /// Add method to get posts by date range
  Future<WPResponse<Post>> getPostsByDate({
    required DateTime after,
    required DateTime before,
    bool inclusive = false,
    String orderBy = PostOrdering.date,
    String order = OrderDirection.desc,
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final filters = PostFilters(
      dateQuery: DateQuery(
        after: after,
        before: before,
        inclusive: inclusive,
      ),
      orderBy: orderBy,
      order: order,
      embed: embed,
    );

    return getPosts(
      filters: filters,
      page: page,
      perPage: perPage,
    );
  }

  /// Add method to get posts by multiple taxonomies
  Future<WPResponse<Post>> getPostsByTaxonomies({
    Map<String, List<int>>? taxonomies,
    String orderBy = PostOrdering.date,
    String order = OrderDirection.desc,
    bool embed = true,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'publish',
      if (embed) '_embed': 'true',
      if (orderBy.isNotEmpty) 'orderby': orderBy,
      if (order.isNotEmpty) 'order': order,
      if (taxonomies != null)
        ...taxonomies.map((key, value) => MapEntry(key, value.join(','))),
    };

    final endpoint = '/wp/v2/posts${_buildQueryString(queryParams)}';

    return _handlePaginatedResponse(
      endpoint,
      () => _dio.get(endpoint),
      (json) => Post.fromMap(json as Map<String, dynamic>),
    );
  }
}
