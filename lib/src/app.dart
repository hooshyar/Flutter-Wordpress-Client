import 'package:flutter/material.dart';
import 'widgets/hawalnir-home.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'widgets/hawalnir-date-convertor.dart';
import '../src/UI/first_fragment.dart';
import '../src/UI/second_fragment.dart';
import '../src/UI/third_fragment.dart';
import '../src/UI/drawerWidget.dart';
//implementing the drawer

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
//end of class drawer

class HawalnirHome extends StatefulWidget {
  

  @override
  State<StatefulWidget> createState() => HawalnirHomeState();
}

class HawalnirHomeState extends State {
  //drawer
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new SecondFragment();
      case 2:
        return new ThirdFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  //drawer

  // Base URL for our wordpress API
  final String apiUrl = "http://ehawal.com/wp-json/wp/v2/";
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(
        Uri.encodeFull(apiUrl + "posts?_embed&per_page=100"),
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
              title: Text("هه‌واڵنێر"), backgroundColor: Colors.blueAccent),

          drawer: mainDrawer(),
          //drawer
          // drawer: new Drawer(
          //  child: new Column(
          //   children: <Widget>[
          //    new UserAccountsDrawerHeader(
          //        accountName: new Text("John Doe"), accountEmail: null),
          //    new Column(children: drawerOptions)
          //    ],
          //  ),
          //),

          //drawer
          //where we have to wrap for pull to refresh
          body: 
              //drawer
              //_getDrawerItemWidget(_selectedDrawerIndex),
              //drawer
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
                          new FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: posts[index]["featured_media"] == 0
                                ? 'images/placeholder.png'
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
