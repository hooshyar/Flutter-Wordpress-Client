import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert';
import 'widgets/catWidgets.dart';
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';
import 'config.dart';
//import 'blocs/item-model.dart';
import 'blocs/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cached_network_image/cached_network_image.dart';

//WPCLIENT_START
import 'package:hawalnir1/wordpress_client.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = 'http://ehawal.com/index.php/wp-json';
//WPCLIENT_END

int perPageInt = int.parse(perPage) ;

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

class HawalnirHome2State extends State {

  //WPCLIENT_START
  var postsCount = 0;

  List<Post> posts;
  List<User> userNames;
  List<Media> medias ;

  Future<List<Post>> getPosts() async {
    //int mediaPerPage = perPage
    posts = await client.listPosts(perPage: perPageInt , injectObjects: true);
    userNames = await client.listUser();

      //dynamic attach =  client.getMedia(mediaID)
      medias = await client.listMedia(perPage: perPageInt);
     // debugPrint("Per Page is " + medias.toString());

    return posts;
  }
  //WPCLIENT_END

     /*
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Post> postList ;
  int count = 0 ;


  // Base URL for our wordpress API
  final String apiUrl = "http://ehawal.com/wp-json/wp/v2/";
  List posts;
  //List kurdistanCatPosts;

  // Function to fetch list of posts
  Future<List<dynamic>> getPosts() async {
    var res = await http
        .get(Uri.encodeFull(apiUrl + "posts?_embed&per_page=10"), //TODO +100
            headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);

      posts = resBody;
    });

    return posts;
  }

  @override
  void initState() {
    super.initState();
    //this.getPosts();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        drawer: drawerMain(context),
        appBar: AppBar(
            title: Text("app 2"), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: FutureBuilder<List<Post>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ListViewPosts2(
                    posts: snapshot.data,
                    users: userNames,
                    medias: medias,
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
