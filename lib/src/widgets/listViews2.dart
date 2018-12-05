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


class ListViewPosts2 extends StatelessWidget {
  final List<Post> posts;

  ListViewPosts2({Key key, this.posts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Text(postsFrom.toString(),
    return  ListView.builder(
                itemCount: posts.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, position) {
                  String authorName = posts[position].authorName;

                  // debugPrint(authorName);
                  dynamic imgUrl = posts[position].featuredMediaUrl;

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
                            placeholder: Image.asset(
                                'assets/images/placeholder.png'),
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
                            title: Text('${posts[position].title}'),
                            subtitle: new Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(authorName.toString())),
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

}

