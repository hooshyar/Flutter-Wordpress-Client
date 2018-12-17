import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../widgets/eachPost.dart';
import '../widgets/catWidgets.dart';
import 'package:hawalnir1/wordpress_client.dart';
import '../blocs/database_helper.dart';
import '../blocs/functions.dart';

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
  Widget build(BuildContext context) {
    getPostsIDs();

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
                  int postID = posts[position].id;
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
