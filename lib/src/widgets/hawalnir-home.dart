import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart'; //transparent image used when trying to lazy load
import 'package:flutter_html/flutter_html.dart'; // pub to load html tags from json api


class HawalnirPost extends StatelessWidget { // i dont know what is the nag 

  final post; //the variable
  HawalnirPost({Key key, @required var this.post}) : super(key: key); //we refer post as required 

  @override
  Widget build(BuildContext context) {
    return new Directionality( //fot the rtl on readmore page
      textDirection: TextDirection.rtl, // wrapped scaffold in the directionly 
      child: new Scaffold(
      appBar: new AppBar(
        title: new Text(post['title']['rendered']), // title gets  the title from post['title'] in api 
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new ListView(

          children: <Widget>[

            new Column(
              children: <Widget>[

                //new Text(
                  //post["_embedded"]["author"][0]["name"]),
               
               // new Html(
                 // data: post["_embedded"]["wp:featuredmedia"][0]["source_url"]),
                 
              ],

            ),

            new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: post["featured_media"] == 0
                  ? 'src/images/placeholder.png'
                  : post["_embedded"]["wp:featuredmedia"][0]["source_url"],
            ),

            
                  

           //new  Directionality(
             // textDirection: TextDirection.rtl,
              new  Html(
                data: post['content']['rendered'], defaultTextStyle: TextStyle(fontFamily: 'NotoKufiArabic',fontSize: 20.0 , decoration:TextDecoration.none )),
                 new Text( "نووسه‌ر: "+
                  post["_embedded"]["author"][0]["name"]),
           // )
            
             ],
        )),
      ),
    );
  }
}