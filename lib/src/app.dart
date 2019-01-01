import 'package:flutter/material.dart';
import 'package:hawalnir1/src/pages/listView.dart';
import 'package:http/http.dart' as http;
import 'widgets/drawerMain.dart';
import 'config.dart';
import 'db/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:hawalnir1/wordpress_client.dart';
import 'db/functions.dart';
import 'package:flutter_offline/flutter_offline.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = mainApiUrl;

var dbHelper = DatabaseHelper();

class HawalnirHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHomeState();
}

class HawalnirHomeState extends State<HawalnirHome>
    with TickerProviderStateMixin {
  var scrollCont =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: drawerMain(context),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: BottomAppBar(
            color: Colors.deepPurple,
            notchMargin: 3.0,
            shape: CircularNotchedRectangle(),
            child: ButtonBar(
              mainAxisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(bottom: 10.0),
                  icon: Icon(Icons.save),
                  splashColor: Colors.blueAccent[200],
                  color: Colors.blueGrey,
                  tooltip: 'save',
                  onPressed: () {
                    Navigator.pushNamed(context, '/InstaPage');
                  },
                ),
                IconButton(
                  padding: EdgeInsets.only(bottom: 10.0),
                  icon: Icon(Icons.favorite),
                  splashColor: Colors.redAccent,
                  color: Colors.blueGrey,
                  tooltip: 'fav',
                  onPressed: () {}, // add +1 to the database
                ),
                Divider(),
                Divider(),
                IconButton(
                  padding: EdgeInsets.only(bottom: 10.0),

                  icon: Icon(Icons.share),
                  color: Colors.blueGrey,
                  tooltip: 'share',
                  onPressed:
                      () {}, // Standard share for whatsapp + google + faccebook + twitter
                ),
                IconButton(
                  padding: EdgeInsets.only(bottom: 10.0),

                  icon: Icon(Icons.home),
                  color: Colors.blueGrey,
                  tooltip: 'home',
                  onPressed:
                      () {}, // Standard share for whatsapp + google + faccebook + twitter
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            isExtended: false,
            elevation: 10.0,
            shape: CircleBorder(),
            child: Icon(Icons.menu),
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              debugPrint("Drawer opened");

              _scaffoldKey.currentState.openEndDrawer();
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomPadding: true,
        body: OfflineBuilder(
            debounceDuration: Duration(seconds: 3),
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return new Stack(
                fit: StackFit.expand,
                children: [
                  FutureBuilder<List<Post>>(
                    future: isExitst(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? ListViewPosts(posts: snapshot.data)
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                  Positioned(
                    height: 24.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: connected ? null : Color(0xFFEE4400),
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("${connected ? '' : 'OFFLINE'}",
                              textDirection: TextDirection.rtl)),
                    ),
                  ),
                ],
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'There are no bottons to push :)',
                ),
                new Text(
                  'Just turn off your internet.',
                ),
              ],
            )));
  }
}
