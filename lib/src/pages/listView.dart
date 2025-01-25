import 'package:flutter/material.dart';
import 'package:hawalnir1/src/widgets/sliver_app_bar.dart';
import '../../src/db/database_helper.dart';
import '../../src/db/functions.dart';
import '../../src/widgets/catWidgets.dart';
import '../../wordpress_client.dart';
import '../config.dart';

class ListViewPosts extends StatefulWidget {
  final List<Post>? posts;
  final WordPressClient client;

  const ListViewPosts({Key? key, required this.posts, required this.client})
      : super(key: key);

  @override
  ListViewPostsState createState() => ListViewPostsState();
}

var scrollCont =
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

class ListViewPostsState extends State<ListViewPosts> {
  var dbHelper = DatabaseHelper();

  int count = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('posts count' + widget.posts!.length.toString());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            displacement: 150.0,
            onRefresh: () => widget.client.getPosts(perPage: defaultPerPage),
            child: CustomScrollView(
              controller: scrollCont,
              slivers: <Widget>[
                SliverAppBarCustomized(),
                sliverListGlobal(widget.posts!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void scrollToTop() {
  scrollCont.animateTo(0.0,
      duration: Duration(seconds: 1), curve: Curves.elasticInOut);
}
