import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import '../widgets/catWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import '../blocs/item-model.dart';

List<Post> postsList;

Post p = Post.fromMapObject({
  // p.id = 1 , title(_id : 1)
});

List posts;

class ListViewPosts extends StatelessWidget {
  final List<dynamic> postsFrom;

  ListViewPosts({Key key, this.postsFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text(postsFrom.toString(),

    return Directionality(
        textDirection: TextDirection.rtl, // RTL
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: getPosts,
            child: ListView.builder(
              //physics: const AlwaysScrollableScrollPhysics(),
              itemCount: postsFrom.length, //== null ? 0 : postsFrom.length,
              itemBuilder: (context, int index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: hawalImage(postsFrom, index),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(5.0),
                        child: new ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    HawalnirPost(post: postsFrom[index]),
                              ),
                            );
                          },
                          title: hawalTitle(postsFrom, index),
                          subtitle: new Row(
                            children: <Widget>[
                              Expanded(
                                child: hawalAuthor(postsFrom, index),
                              ),
                              Expanded(
                                child: hawalDate(postsFrom, index),
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
              },
            ),
          ),
        ));
  }
}

Future<void> getPosts() async {
  var res = await http
      .get(Uri.encodeFull(mainApiUrl + "posts?_embed&per_page=10"), //TODO +100
          headers: {"Accept": "application/json"});

  var resBody = json.decode(res.body);

  return posts = resBody;
}
