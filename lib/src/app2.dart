import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert';
import 'widgets/catWidgets.dart';
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';
import 'config.dart';
import 'blocs/item-model.dart';
import 'blocs/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class HawalnirHome2 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

class HawalnirHome2State extends State {



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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        drawer: drawerMain(context),
        appBar: AppBar(
            title: Text("app 2"), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: FutureBuilder<List<dynamic>>(
            future: getPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                //TODO show cached posts
                return connectionErrorBar();

              } else {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListViewPosts2(postsFrom: snapshot.data);
                }
              }

            }),
      ),
    );
  }

  void _delete(BuildContext context, Post post) async {
    int result = await databaseHelper.deletePost(post.id);
  }

}

