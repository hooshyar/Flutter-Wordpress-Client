import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
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

var scrollCont =
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

class ListViewPosts2State extends State<ListViewPosts2> {
  var dbHelper = DatabaseHelper();
  List<Post> postList;
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPostsIDs();

    //debugPrint(postList.toString()) ;
    // return Text(postsFrom.toString(),

    return OfflineBuilder(
      debounceDuration: Duration(seconds: 3),
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        return new Stack(
          fit: StackFit.expand,
          children: [
            ListView.builder(
                controller: scrollCont,
                itemCount: posts.length, //posts.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, position) {
                  String authorName = posts[position].author;
                  int postID = posts[position].id;
                  // debugPrint(authorName);
                  dynamic imgUrl = posts[position].featuredMediaUrl;
                  //dbHelper.insertPost(posts[position]) ;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Hero(
                                tag: 'hero$postID',
                                child: hawalImage(posts[position])),

                            //Todo Put it on stack
                          ],
                        ),
                        new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //fullscreenDialog: true,
                                  builder: (context) =>
                                      HawalnirPost(post: posts[position]),
                                ),
                              );
                            },
                            title: hawalTitle(posts[position]),
                            subtitle: Row(
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
                }),
            Positioned(
              height: 24.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                child: Center(
                  child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                ),
              ),
            ),
          ],
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'There are no bottons to push :)',
          ),
          new Text(
            'Just turn off your internet.',
          ),
        ],
      ),
    );
  }
}

//  void updateListView() {
//    final Future<Database> dbFuture = dbHelper.initDatabase();
//    dbFuture.then((database) {
//      Future<List<Post>> noteListFuture = dbHelper.getPostList();
//      noteListFuture.then((postList) {
//        setState(() {
//          this.postList = postList;
//          this.count = postList.length;
//        });
//      });
//    });
//  }
//}
