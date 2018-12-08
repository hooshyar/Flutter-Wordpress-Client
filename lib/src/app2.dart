import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert';
import 'widgets/catWidgets.dart';
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';
import 'config.dart';
//import 'blocs/item-model.dart';
import 'blocs/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cached_network_image/cached_network_image.dart';

//WPCLIENT_START
import 'package:hawalnir1/wordpress_client.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = 'http://ehawal.com/index.php/wp-json';
//WPCLIENT_END

var dbHelper = DatabaseHelper();
int perPageInt = int.parse(perPage);

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

List<Post> cachedPosts;
List<Post> posts;
int dbCount = 0 ;

Future<List<Post>> whichPosts() async {
  int count = await dbHelper.getCount();
  debugPrint('Count is $count');
  dbCount = count ;

  if (count <= 1) {
    return getPosts();
  } else {
    return getPostsFromDB();
  }
}

Future<List<Post>> getPostsFromDB() async {
  cachedPosts = await dbHelper.getPostList();
  debugPrint('from DataBAse');
//  debugPrint(cachedPosts.toString());
  posts = cachedPosts ;
  return posts;
}

Future<List<Post>> getPosts() async {
  posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
  cachedPosts = await dbHelper.getPostList();

  debugPrint(cachedPosts.toString()) ;
  debugPrint('from Wordpress API');
  //from here

  if (dbHelper.colId.contains((posts[0].id).toString())) {
    debugPrint("col id is " + dbHelper.colId);
    debugPrint("post id is  " + (posts[0].id).toString());

    List<int> cachedPostsIds;
    for (int i = 0; i < cachedPosts.length; i++) {
      cachedPostsIds[i] = cachedPosts[i].id;
      debugPrint('cached Posts ids are ' + cachedPostsIds.toString());
    }

    for (int j = 0; j < posts.length; j++) {
      if (cachedPostsIds[j] == posts[0].id) {
        debugPrint('post exxist');
      }
      //from here
      cachedPosts = posts;
    }




  }else {
    debugPrint("dbCOunt is : " + dbCount.toString());
    for(int i = 0 ; i<dbCount ; i++){
      dbHelper.deletePost(posts[i].id) ;
    }




    for(int i = 0 ; i< perPageInt ; i++){
      dbHelper.insertPost(posts[i]) ;
    }

  }
  return posts;
}

class HawalnirHome2State extends State {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        drawer: drawerMain(context),
        appBar: AppBar(
            title: Text("app 2"), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: RefreshIndicator(
          onRefresh: getPosts,
          child: FutureBuilder<List<Post>>(
            future: whichPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? ListViewPosts2(posts: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
