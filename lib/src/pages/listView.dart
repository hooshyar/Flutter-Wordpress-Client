import 'package:flutter/material.dart';
import '../../src/db/database_helper.dart';
import '../../src/db/functions.dart';
import '../../src/widgets/catWidgets.dart';
import '../../wordpress_client.dart';

class ListViewPosts extends StatefulWidget {
  final List<Post> posts;

  ListViewPosts({Key key, this.posts}) : super(key: key);

  @override
  ListViewPostsState createState() {
    return new ListViewPostsState();
  }
}

var scrollCont =
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

class ListViewPostsState extends State<ListViewPosts> {
  var dbHelper = DatabaseHelper();
  List<Post> postList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    getPostsIDs();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            displacement: 150.0,
            onRefresh: isExitst,
            child: CustomScrollView(
              controller: scrollCont,
              slivers: <Widget>[
                sliverAppBarGlobal(),
                sliverListGlobal(widget.posts),
              ],
            ),
          ),
//            _buildFab(),
        ],
      ),
    );
  }
}

void scrollToTop() {
  scrollCont.animateTo(0.0,
      duration: Duration(seconds: 1), curve: Curves.elasticInOut);
}
