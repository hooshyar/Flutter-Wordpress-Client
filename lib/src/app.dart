import 'package:flutter/material.dart';
import 'widgets/eachPost.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import 'widgets/hawalnir-date-convertor.dart';
//import 'dart:collection';
//import 'dart:core';

class HawalnirHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHomeState();
}

class HawalnirHomeState extends State {
  // Base URL for our wordpress API
  final String apiUrl = "http://ehawal.com/wp-json/wp/v2/";
  final String kurdistanUrl = " ";
  List posts;
  //List kurdistanCatPosts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http
        .get(Uri.encodeFull(apiUrl + "posts?_embed&per_page=10"), //TODO +100
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
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
        //where i add Dictio for rtl  entire home page , i wraped every thing into this
        textDirection: TextDirection.rtl, // RTL
        child: new Scaffold(
          // Scaffold az a Child, it takes only one child
          appBar: AppBar(
            title: Text("هه‌واڵنێر") ,
            
             ),

          drawer: Drawer(
            child: ListView(
              //physics: BouncingScrollPhysics(),

              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text("data"),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                  ),
                ),
                socialBtn("فه‌یسبوك", Icons.closed_caption, Colors.indigo[900]),
                drawerBtnPadding(),
                socialBtn("تویتته‌ر", Icons.access_alarms, Colors.indigo[900]),
                drawerBtnPadding(),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text("بابه‌ته‌كانی هه‌واڵ"),
                  children: <Widget>[
                    drawerBtn(" كوردستان", () {
                      // we want to close the drawer
                      Navigator.of(context).pop(); //TODO Find a better way
                      Navigator.pushNamed(
                          context, '/KrdCat'); // => KurdistanCat.dart
                    }),
                    drawerBtnPadding(),
                    drawerBtn(" grng", () {
                      // we want to close the drawer
                      Navigator.of(context).pop(); //TODO Find a better way
                      Navigator.pushNamed(
                          context, '/GrngCat'); // => KurdistanCat.dart
                    }),
                    drawerBtn("ئابوری", (){
                      print("object") ;
                    }),
                    drawerBtnPadding(),
                  ],
                  
                ),
                drawerBtn("text", () {
                  print('object2');
                }),
              ],
            ),
          ),

          //where we have to wrap for pull to refresh
          body: RefreshIndicator(
            onRefresh: getPosts,
            //there was an error when i used getPosts(); so i removed prantisice
            child: ListView.builder(
              itemCount: posts == null ? 0 : posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  
                  children: <Widget>[
                    Card(
                      shape:RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(20.0)) ),
                      clipBehavior: Clip.hardEdge,
                      child: Column( 
                        
                        children: <Widget>[
                          new FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: posts[index]["featured_media"] == 0
                                ? 'assets/images/placeholder.png'
                                : posts[index]["_embedded"]["wp:featuredmedia"]
                                    [0]["source_url"],
                          ),
                          new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new HawalnirPost(
                                        post: posts[index]),
                                        
                                         //post by post
                                  ),
                                );
                               
                              },
                              title: new Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child:
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
                                      dateConvertor(
                                          posts[index]["date"].toString()),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
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
        ));
  }
}

Widget kurdistanCatBtn() {
//String text ;

  return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          elevation: 2.0,
          //textTheme: ButtonTextTheme.primary,
          splashColor: Colors.cyan,
          textColor: Colors.black,
          colorBrightness: Brightness.dark,

          child: Text("په‌ری كوردستان"),

          padding: EdgeInsets.all(20.0),
          animationDuration: Duration(microseconds: 200),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          color: Colors.amber,
          onPressed: () {},
        ),
      ]);
}

Widget drawerBtn(String text, Function function) {
//String text ;

  return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          elevation: 2.0,
          //textTheme: ButtonTextTheme.primary,
          splashColor: Colors.cyan,
          textColor: Colors.black,
          colorBrightness: Brightness.dark,

          child: Text(text),

          padding: EdgeInsets.all(20.0),
          animationDuration: Duration(microseconds: 200),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          color: Colors.amber,
          onPressed: function,
        ),
      ]);
}

//btn social
Widget socialBtn(String text, IconData iconData, Color color) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Padding(
        // padding: EdgeInsets.all(20.0),
        //),
        RaisedButton(
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.cyan,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                text,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          elevation: 2.0,
          //textTheme: ButtonTextTheme.primary,
          splashColor: Colors.cyan,
          textColor: Colors.black,
          colorBrightness: Brightness.dark,
          padding: EdgeInsets.all(20.0),

          animationDuration: Duration(microseconds: 200),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.0))),
          color: color,
          onPressed: () {},
        ),
      ]);
}

Widget drawerBtnPadding() {
  return Padding(
    padding: EdgeInsets.all(5.0),
  );
}
