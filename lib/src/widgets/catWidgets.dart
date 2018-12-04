import 'package:flutter/material.dart';
import 'hawalnir-date-convertor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../../wordpress_client.dart';

Widget hawalImage(List<dynamic> posts, int index) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/placeholder.png',
    image: posts[index]["featured_media"] == 0
        ? 'assets/images/placeholder.png'
        : posts[index]["_embedded"]["wp:featuredmedia"][0]["source_url"],
  );
}

Widget hawalTitle(List<dynamic> posts, int index) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: // Text("data")
        new Text(posts[index]["title"]["rendered"]),
  );
}

Widget hawalAuthor(List<dynamic> posts, int index) {
  return Text(
    "نووسه‌ر: " + posts[index]["_embedded"]["author"][0]["name"],
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
