import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../client.dart';
import '../models/post.dart';
import 'database_helper.dart';

class DatabaseFunctions {
  final WordPressClient client;
  final DatabaseHelper dbHelper;
  final SharedPreferences prefs;

  DatabaseFunctions({
    required this.client,
    required this.dbHelper,
    required this.prefs,
  });

  List<Post>? _cachedPosts;
  List<Post>? _posts;
  bool _hasNetworkConnection = false;

  Future<bool> checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      _hasNetworkConnection =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return _hasNetworkConnection;
    } on SocketException catch (_) {
      _hasNetworkConnection = false;
      return false;
    }
  }

  Future<void> clearDatabase() async {
    final count = await dbHelper.getCount();
    debugPrint('Clearing database with $count items');

    if (_cachedPosts != null) {
      for (final post in _cachedPosts!) {
        await dbHelper.deletePost(post.id);
        debugPrint('Deleted post ${post.id} from database');
      }
    }
  }

  Future<void> fillDatabase(List<Post> posts) async {
    for (final post in posts) {
      await dbHelper.insertPost(post);
      debugPrint('Inserted post ${post.id} to database');
    }
  }

  Future<List<Post>> getPosts() async {
    final hasNetwork = await checkNetworkConnection();
    _cachedPosts = await dbHelper.getPostList();

    if (!hasNetwork) {
      debugPrint('No network connection, using cached posts');
      if (_cachedPosts?.isEmpty ?? true) {
        throw Exception('No cached posts available and no network connection');
      }
      _posts = _cachedPosts;
    } else {
      debugPrint('Network available, fetching fresh posts');
      final response = await client.getPosts(perPage: defaultPerPage);
      _posts = response.items;

      // Update cache if new posts are available
      if (!_arePostsEqual(_posts!, _cachedPosts ?? [])) {
        await clearDatabase();
        await fillDatabase(_posts!);
        debugPrint('Updated cache with new posts');
      }
    }

    // Sort posts by ID in descending order
    _posts?.sort((a, b) => b.id.compareTo(a.id));
    return _posts ?? [];
  }

  bool _arePostsEqual(List<Post> newPosts, List<Post> cachedPosts) {
    if (newPosts.length != cachedPosts.length) return false;

    for (var i = 0; i < newPosts.length; i++) {
      if (newPosts[i].id != cachedPosts[i].id) return false;
    }

    return true;
  }
}
