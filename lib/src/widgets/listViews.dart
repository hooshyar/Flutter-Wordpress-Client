import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import '../widgets/catWidgets.dart';
import '../config.dart';
class ListViewPosts extends StatelessWidget {
  final List<String> posts;

  ListViewPosts({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

        Container(
        child: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
      return Column(
        children: <Widget>[



          Card(
            child: Column(
              children: <Widget>[

                Container(

                  child: hawalImage(posts, index),

                ),


                new Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              HawalnirPost(post: posts[index]),
                        ),
                      );
                    },
                    title: hawalTitle(posts, index),

                    subtitle: new Row(
                      children: <Widget>[
                        Expanded(
                          child: hawalAuthor(posts, index),
                        ),
                        Expanded(
                          child: hawalDate(posts, index),
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
          )
        ],
      );
    },
    ),
      );}

}