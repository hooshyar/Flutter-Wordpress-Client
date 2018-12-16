import 'package:flutter/material.dart';
import 'hawalnir-date-convertor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../../wordpress_client.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget hawalImage(Post post) {
  return Stack(
    children: <Widget>[
      Positioned(

    bottom: 5.0,
    right: 0,
    left: 0,
    child: Container(

      decoration: BoxDecoration(
         boxShadow:[
        BoxShadow(
          spreadRadius: 10,
          blurRadius: 20,
        color: Colors.blue,
        offset: new Offset(1.0, 1.0),
      ) ,
      ] ,
    ),
    ),
  ),

  Container(

        foregroundDecoration: BoxDecoration(


            backgroundBlendMode: BlendMode.overlay,
//        borderRadius:
//        BorderRadius.all(Radius.circular(20.0)),


            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],

              colors: [

                // Colors are easy thanks to Flutter's Colors class.

                Colors.transparent,
                Colors.transparent,
                Colors.black45,
                Colors.black87 ,
              ],

            )),
        child: CachedNetworkImage(
          fadeInCurve: Curves.decelerate,
          repeat: ImageRepeat.noRepeat,
          fadeInDuration: Duration(seconds: 5),

          imageUrl: post.featuredMediaUrl == null
              ? 'assets/images/placeholder.png'
              : post.featuredMediaUrl,
          placeholder: Image.asset('assets/images/placeholder.png'),
          errorWidget: Container(
            child:  Image.asset('assets/images/placeholder.png'),
          ),
        ),
      )
    ],

  );
}




Widget hawalTitle(Post post) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: // Text("data")
        Html(data: post.title ,
          defaultTextStyle: TextStyle(
        //fontFamily: 'NotoKufiArabic',
          fontSize: 20.0,
          decoration: TextDecoration.none)) ,


  );
}

Widget hawalAuthor(Post post) {
  return Text(
    "نووسه‌ر: " + post.author,
    textAlign: TextAlign.right,
  );
}

Widget hawalDate(Post post) {
  return Text(
    dateConvertor(post.date.toString()),
    textAlign: TextAlign.left,
  );
}

Widget hawalBtnBar() {
  return ButtonBar(
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.save),
        splashColor: Colors.blueAccent[200],
        color: Colors.blueGrey,
        tooltip: 'پاشكه‌وت كردنی بابه‌ت',
        onPressed: () {}, // add +1 to the database
      ),
      IconButton(
        icon: Icon(Icons.favorite),
        splashColor: Colors.redAccent,
        color: Colors.blueGrey,
        tooltip: 'په‌سه‌ند كردن',
        onPressed: () {}, // add +1 to the database
      ),
      IconButton(
        icon: Icon(Icons.share),
        color: Colors.blueGrey,
        tooltip: 'بو هاورێكانت بنێره‌',
        onPressed:
            () {}, // Standard share for whatsapp + google + faccebook + twitter
      ),
    ],
  );
}

Future<List<dynamic>> getPosts2(
  String apiUrl,
  String categoryId,
  String hawalPerPage,
) async {
  List<dynamic> posts2;
  var res = await http.get(
      Uri.encodeFull(apiUrl +
          "posts?_embed&categories=$categoryId&per_page=$hawalPerPage"), // Works Uri.encodeFull(apiUrl + "posts?categories=7278"),
      headers: {"Accept": "application/json"});
  var resBody = json.decode(res.body);
  posts2 = resBody;
  //print(posts2);
  return posts2;
}

Widget connectionErrorBar (){
  return Container(

    alignment: Alignment.bottomCenter,

    child: SnackBar(
      duration: Duration(milliseconds: 200)  ,
      animation: kAlwaysCompleteAnimation ,
      content: Text(connectionProblemError),

    ),
  );
}

Widget HeroText(){

  Text('Hero Texxt jfsfkdjalkgjsfkljb jdlkfjlkdsjfglkdfjglkdsjfklgjdfklgjkldb lkdsj lkj lksdjfb lk jkldj lkdfsj lkdjl ' ,
    style: TextStyle(
      color: Colors.cyan ,
          fontSize: 30.0 ,
    ),
  textScaleFactor: 2.0,);
}