import 'package:flutter/material.dart';
import 'widgets/eachPost.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import 'widgets/hawalnir-date-convertor.dart';
//import 'dart:collection';
//import 'dart:core';
import 'widgets/catWidgets.dart';
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

class HawalnirHome2State extends State {
  // Base URL for our wordpress API
  final String apiUrl = "http://ehawal.com/wp-json/wp/v2/";
  final String kurdistanUrl = " ";
  List posts;
  //List kurdistanCatPosts;

  // Function to fetch list of posts
  Future <List<dynamic>> getPosts() async {
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
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ListViewPosts2(postsFrom: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}


