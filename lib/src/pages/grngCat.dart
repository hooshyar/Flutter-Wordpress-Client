import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import '../widgets/catWidgets.dart';
import '../config.dart';

class GrngCat extends StatefulWidget {
  _GrngCatState createState() => _GrngCatState();
}

class _GrngCatState extends State<GrngCat> {


  final String apiUrl = mainApiUrl ;
  List posts;
  String categoryId = grngId ;
  String hawalPerPage = perPage;

  Future getPosts() async {
    var res = await http.get(
        Uri.encodeFull(apiUrl +
            "posts?_embed&categories=$categoryId&per_page=$hawalPerPage"), // Works Uri.encodeFull(apiUrl + "posts?categories=7278"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
      //posts = database resbody if listens and found new then reloads


    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    //this.getPosts();


    //this.getKurdistanCatPosts(); //have to go to its own page
  }

  @override
  Widget build(BuildContext context) {

    RefreshIndicator(
      onRefresh: getPosts,
      //there was an error when i used getPosts(); so i removed prantisice
      child: Directionality(
      //where i add Dictio for rtl  entire home page , i wraped every thing into this
      textDirection: TextDirection.rtl, // RTL
      child: new Scaffold(
        // Scaffold az a Child, it takes only one child
        appBar: AppBar(
            title: Text("هه‌واڵی كوردستان"),//TODO edit this
            backgroundColor: Colors.blueAccent),

        body:FutureBuilder<List<String>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? posts= snapshot.data
                : Center(child: CircularProgressIndicator());

          },
        )

        ),
      ),
    );
  }
}
