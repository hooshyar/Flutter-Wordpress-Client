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

int perPageInt = int.parse(perPage);

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

class HawalnirHome2State extends State {

  List<Post> posts;


  Future<List<Post>> getPosts() async {
    posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        drawer: drawerMain(context),
        appBar: AppBar(
            title: Text("app 2"), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: FutureBuilder<List<Post>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ListViewPosts2(posts: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
