import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // pub to load html tags from json api
import 'hawalnir-date-convertor.dart';
import 'package:hawalnir1/wordpress_client.dart';

class HawalnirPost extends StatelessWidget {
  // i dont know what is the nag

  Post post; //the variable
  HawalnirPost({Key key, @required var this.post})
      : super(key: key); //we refer post as required

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      //fot the rtl on readmore page
      textDirection: TextDirection.rtl, // wrapped scaffold in the directionly
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(post.title), // title gets  the title from post['title'] in api
        ),
        body: new Padding(
            padding: EdgeInsets.all(16.0),
            child: new ListView(
              children: <Widget>[
                new Column(
                  //rossAxisAlignment: CrossAxisAlignment.stretch,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    mainImage(post),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: authorEmbedded(post),
                        ),
                        Expanded(
                          child: dateMain(post),
                        ),
                      ],
                    ),
                    Divider(),
                    contentRendered(post),
                  ],
                ),
              ],
            )),
      ),
    );





  }




  Widget mainImage(Post post) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/placeholder.png',
      image: post.featuredMediaUrl  == 0
          ? 'src/images/placeholder.png'
          : post.featuredMediaUrl,
    );
  }

  Widget contentRendered(Post post) {
    return Html(
        data: post.content.toString(),
        defaultTextStyle: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 20.0,
            decoration: TextDecoration.none));
  }

  Widget authorEmbedded(Post post) {
    return Text(
      "نووسه‌ر: " + post.authorName ,
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

