import 'package:flutter/material.dart';
import '../widgets/hawalnir-home.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import '../widgets/hawalnir-date-convertor.dart';

class KrdCat extends StatefulWidget {
  _KrdCatState createState() => _KrdCatState();
}

class _KrdCatState extends State<KrdCat> {
  final String apiUrl = "http://ehawal.com/wp-json/wp/v2/";
  final String kurdistanUrl = " ";
  List posts;
  //List kurdistanCatPosts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(
        Uri.encodeFull(apiUrl +
            "posts?_embed&categories=7278&per_page=3"), // Works Uri.encodeFull(apiUrl + "posts?categories=7278"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
    //this.getKurdistanCatPosts(); //have to go to its own page
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      //where i add Dictio for rtl  entire home page , i wraped every thing into this
      textDirection: TextDirection.rtl, // RTL
      child: new Scaffold(
        // Scaffold az a Child, it takes only one child
        appBar: AppBar(
            title: Text("هه‌واڵی كوردستان"),
            backgroundColor: Colors.blueAccent),

        body: 
          RefreshIndicator(
            onRefresh: getPosts,
            //there was an error when i used getPosts(); so i removed prantisice
            
          child: ListView.builder(
            itemCount: posts == null ? 0 : posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[

                           FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                            image:
                             posts[index]["featured_media"] == 0
                                ? 'assets/images/placeholder.png'
                                : posts[index]["_embedded"]["wp:featuredmedia"]
                                    [0]["source_url"],
                          ), 

                        //new ListTile(
                        //  title:Text(posts[index]["author"]["rendered"].toString()) , //trying to fetch authors name
                        //),

                        new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) =>
                                      new KurdistanPost(post: posts[index]),
                                ),
                              );
                            },
                            title: new Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: // Text("data")
                                  new Text(posts[index]["title"]["rendered"]),
                            ),

                            subtitle: new Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "نووسه‌ر: " +
                                        posts[index]["_embedded"]["author"][0]
                                            ["name"],
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    DateConvertor(
                                        posts[index]["date"].toString()),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),

                            //subtitle: new Text(    // here i disabled subtitle
                            //posts[index]["excerpt"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '') //contetn is a object so how to use a array or string
                            // ),
                          ),
                        ),
                        new ButtonTheme.bar(
                          child: new ButtonBar(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.save),
                                splashColor: Colors.blueAccent[200],
                                color: Colors.blueGrey,
                                tooltip: 'پاشكه‌وت كردنی بابه‌ت',
                                onPressed: () {
                                  setState(() {});
                                }, // add +1 to the database
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite),
                                splashColor: Colors.redAccent,
                                color: Colors.blueGrey,
                                tooltip: 'په‌سه‌ند كردن',
                                onPressed: () {
                                  setState(() {});
                                }, // add +1 to the database
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                color: Colors.blueGrey,
                                tooltip: 'بو هاورێكانت بنێره‌',
                                onPressed: () {
                                  setState(() {});
                                }, // Standard share for whatsapp + google + faccebook + twitter
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
