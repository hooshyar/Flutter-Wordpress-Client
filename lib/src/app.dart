import 'package:flutter/material.dart';
import 'widgets/hawalnir-home.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import 'widgets/hawalnir-date-convertor.dart';
import 'pages/kurdistan-cat.dart';
//import '../src/UI/drawerWidget.dart'; //Drawer widget
//implementing the drawer

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
    var res = await http.get(
        Uri.encodeFull(apiUrl + "posts?_embed&per_page=10"), //TODO +100
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);

      posts = resBody;
    });

    return "Success!";
  }

/*
  //getting posts of Kurdistan Category 
  Future<String> getKurdistanCatPosts() async {
    var res = await http.get(
        Uri.encodeFull(apiUrl + "posts?categories=7278&perpage=10"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);

      kurdistanCatPosts = resBody;
    });

    return "Success!";
  }
  //end of getting kurdistanCatPosts
*/
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
              title: Text("هه‌واڵنێر"), backgroundColor: Colors.blueAccent),

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
                    //temp has to be in app dart
                    FlatButton(
                        child: Text("هه‌واڵه‌كانی كوردستان"),
                        onPressed: () {
                          // we want to close the drawer
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/KrdCat');
                         
                          //TODO Navigator.of(context).pushNamed('/screen2'););
                        }),
                    
                    // temp
                    drawerBtn(" كوردستان"),
                    drawerBtnPadding(),
                  ],
                ),
                drawerBtn("text"),
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
                      child: Column(
                        children: <Widget>[
                          new FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: posts[index]["featured_media"] == 0
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
                                        new HawalnirPost(post: posts[index]),
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

//kurdistanposts
/*
class KurdistanCatPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("هه‌واڵه‌كانی كوردستان"),
      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                button2(context);
              },
              child: new Text("Back to Screen 1"),
            )
          ],
        ),
      ),
    );
  }
}
//Kurdistan posts
*/
void button1(BuildContext context) {
  print("Button 1"); //1
  Navigator.of(context).pushNamed('/screen2'); //2
}

void button2(BuildContext context) {
  print("Button 2"); //3
  Navigator.of(context).pop(true); //4
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("هه‌واڵه‌كانی كوردستان"),
      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                button2(context);
              },
              child: new Text("Back to Screen 1"),
            )
          ],
        ),
      ),
    );
  }
}

Widget drawerBtn(String text) {
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
          onPressed: () {},
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
