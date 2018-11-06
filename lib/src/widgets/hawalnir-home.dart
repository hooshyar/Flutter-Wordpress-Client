import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
//import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_html/flutter_html.dart';


class HawalnirPost extends StatelessWidget {

  var post;
  HawalnirPost({Key key, @required var this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
      appBar: new AppBar(
        title: new Text(post['title']['rendered']),
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new ListView(

          children: <Widget>[
            new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: post["featured_media"] == 0
                  ? 'src/images/placeholder.png'
                  : post["_embedded"]["wp:featuredmedia"][0]["source_url"],
            ),
           //new  Directionality(
             // textDirection: TextDirection.rtl,
              new  Html(
                data: post['content']['rendered'], defaultTextStyle: TextStyle(fontFamily: 'serif',fontSize: 20.0 , decoration:TextDecoration.none ))
                 
           // )
           // new Text(
             // post['content']['rendered'].replaceAll(new RegExp(r'<[^>]*>'), '') , textDirection: TextDirection.rtl,)
             ],
        )),
      ),
    );
  }
}