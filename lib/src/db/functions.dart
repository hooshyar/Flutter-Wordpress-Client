import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import '../config.dart';
import '../db/database_helper.dart';
import 'dart:io';
import 'package:hawalnir1/wordpress_client.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = mainApiUrl;

var dbHelper = DatabaseHelper();
int perPageInt = int.parse(perPage);

List<Post> cachedPosts;
List<Post> posts;
int dbCount;
bool netConnection = false;

List<int> postsIDs = List();
List<int> cachedPostsIDs = List();

getCachedPostsIDs() {
  for (int i = 0; i < cachedPosts.length; i++) {
    cachedPostsIDs.add(cachedPosts[i].id);
  }
}

getPostsIDs() {
  for (int i = 0; i < posts.length; i++) {
    postsIDs.add(posts[i].id);
  }
}

clearDB() async {
  int count = await dbHelper.getCount();

  debugPrint("count is :  " + count.toString());
  for (int i = 0; i < count; i++) {
    dbHelper.deletePost(cachedPosts[i].id);
    debugPrint("this post has been deleted" + (posts[i].id).toString());
    debugPrint("${cachedPosts[i].id} has been Deleted from  DB");
  }
}

fillDB() {
  for (int i = 0; i < posts.length; i++) {
    dbHelper.insertPost(posts[i]);
    debugPrint("${posts[i].id} has been inserted to DB");
  }
}

doWeHaveNet() async {
  int count = await dbHelper.getCount();
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      netConnection = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    if (count < 1) {
      debugPrint('we need intenet');
      netConnection = false;
    }
  }
}

Future<List<Post>> getPosts() async {
  posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
  return posts ;
}


Future<List<Post>> isExitst() async {
  doWeHaveNet();
  cachedPosts = await dbHelper.getPostList();

  if (netConnection != true) {
    debugPrint("doWeHaveNet() is != true ");
    posts = cachedPosts;
    posts.sort((a, b) => b.id.compareTo(a.id));
  } else {
    debugPrint("doWeHaveNet() is == true ");
    posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
  }

  bool foundPost = true;
  getPostsIDs();
  getCachedPostsIDs();
  debugPrint('Posts Ids are: ' + postsIDs.toString());
  debugPrint('Cached pOsts ids are : ' + cachedPostsIDs.toString());

  if (cachedPosts.length < 1) {
    debugPrint('No Cached Posts Has Been FOUND');
    posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
    fillDB();
    return posts ;

  } else {
    for (int i = 0; i < cachedPostsIDs.length; i++) {
      for (int j = 0; j < postsIDs.length; j++) {
        if (cachedPostsIDs.contains(postsIDs[j])) {
          debugPrint("FOUND ${postsIDs[j]} post in the database");
          foundPost = true;
        } else {
          foundPost = false;
          debugPrint("COULDNT FFIND ${postsIDs[j]} in cachedPostsIDs");
          break;
        }
      }

      if (foundPost == true) {
        for (int i = 0; i < posts.length; i++) {
          posts[i] = cachedPosts[i];
        }

        debugPrint('found post is TRUE ');
      } else {
        debugPrint('found post is NOT TRUE');
        posts = posts;
        await dbHelper.deleteDB();
        fillDB();
        debugPrint('DATABASE HAS BEEN DELETED');
      }
    }
  }
  posts.sort((a, b) => b.id.compareTo(a.id));
  return posts;
}
