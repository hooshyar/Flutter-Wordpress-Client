import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/post.dart';
import 'package:hawalnir1/wordpress_client.dart';

import 'catWidgets.dart';
import 'hawalnir-date-convertor.dart';

class HawalnirPost extends StatelessWidget {
  HawalnirPost({Key? key, required var this.post}) : super(key: key);
  final Post? post;

  @override
  Widget build(BuildContext context) {
    debugPrint(post!.id.toString());

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: Container(
          width: double.infinity,
          child: hawalTitle(post!),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: new Padding(
          padding: EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(tag: 'hero${post!.id}', child: hawalImage(post!)),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: hawalBtnBar(),
                      ),
                    ],
                  ),
                  hawalTitle(post!),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: hawalAuthor(post!),
                      ),
                      Expanded(
                        child: hawalDate(post!),
                      ),
                    ],
                  ),
                  Divider(),
                  contentRendered(post!),
                ],
              ),
            ],
          )),
    );
  }

  Widget mainImage(Post post) {
    return FadeInImage.assetNetwork(
      placeholder: 'https://via.placeholder.com/300.png/09f/fff',
      image: post.featuredMediaUrl?.toString() ?? 'src/images/placeholder.png',
    );
  }

  Widget titleRendered(Post post) {
    return Html(
      data: post.title.rendered,
      style: {
        "div": Style(
          fontSize: FontSize(20),
        ),
      },
    );
  }

  Widget contentRendered(Post post) {
    return Html(
      data: post.content.rendered,
      style: {
        "div": Style(
          fontSize: FontSize(20),
        ),
      },
    );
  }

  Widget authorEmbedded(Post post) {
    return Text(
      "author: " + post.author!,
      textAlign: TextAlign.right,
    );
  }

  Widget dateMain(Post post) {
    return Text(
      dateConvertor(post.date.toString()),
      textAlign: TextAlign.left,
    );
  }
}
