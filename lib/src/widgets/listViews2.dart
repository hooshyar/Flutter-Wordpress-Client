import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import '../widgets/catWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import 'package:hawalnir1/wordpress_client.dart';
import '../app2.dart';
import '../client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/database_helper.dart';
import 'package:sqflite/sqflite.dart';

//DataBase

class ListViewPosts2 extends StatefulWidget {
  final List<Post> posts;

  ListViewPosts2({Key key, this.posts}) : super(key: key);

  @override
  ListViewPosts2State createState() {
    return new ListViewPosts2State();
  }
}

class ListViewPosts2State extends State<ListViewPosts2> {
  var dbHelper = DatabaseHelper();
  List<Post> postList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    updateListView();
    //debugPrint(postList.toString()) ;
    // return Text(postsFrom.toString(),
    return ListView.builder(
        itemCount: posts.length, //posts.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, position) {
          String authorName = posts[position].author;

          // debugPrint(authorName);
          dynamic imgUrl = posts[position].featuredMediaUrl;
          //dbHelper.insertPost(posts[position]) ;
          return Card(
            child: Column(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.decelerate,
                    repeat: ImageRepeat.noRepeat,
                    fadeInDuration: Duration(seconds: 5),
                    imageUrl: imgUrl == null
                        ? 'assets/images/placeholder.png'
                        : imgUrl,
                    placeholder: Image.asset('assets/images/placeholder.png'),
                    errorWidget: new Icon(Icons.error),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              HawalnirPost(post: posts[position]),
                        ),
                      );
                    },
                    title: hawalTitle(posts[position]),
                    subtitle: new Row(
                      children: <Widget>[
                        Expanded(child: hawalAuthor(posts[position])),
                        Expanded(
                          child: hawalDate(posts[position]),
                        ),
                      ],
                    ),
                  ),
                ),
                new ButtonTheme.bar(
                  child: hawalBtnBar(),
                ),
              ],
            ),
          );
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<Post>> noteListFuture = dbHelper.getPostList();
      noteListFuture.then((postList) {
        setState(() {
          this.postList = postList;
          this.count = postList.length;
        });
      });
    });
  }
}
