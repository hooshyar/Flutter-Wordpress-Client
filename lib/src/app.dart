import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:hawalnir1/src/pages/listView.dart';
import 'package:hawalnir1/src/view_models/app_key.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'widgets/drawerMain.dart';
import 'config.dart';
import 'db/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:hawalnir1/wordpress_client.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Provider.of<Keys>(context).appScaffoldKey,
        endDrawer: drawerMain(context),
        // bottomNavigationBar: bottomNavAppBar(),
        // floatingActionButton:
        //  FloatingActionButton(
        //     isExtended: false,
        //     elevation: 10.0,
        //     shape: CircleBorder(),
        //     child: Icon(Icons.menu),
        //     backgroundColor: Colors.deepPurple,
        //     onPressed: () {
        //       appScaffoldKey.currentState.openEndDrawer();
        //     }),
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
                  Container(
                    child: FutureBuilder<List<Post>>(
                      future: client.listPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ? ListViewPosts(posts: snapshot.data)
                            : Center(child: CircularProgressIndicator());
                      },
                    ),
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                 
                    child: Container(
                     
                      color: Colors.deepPurple.withOpacity(0.8),
                      child: 
                      
                      bottomNavAppBar(),
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

  bottomNavAppBar() {
    return ClipRect(
          child: Container(
        height: 80,
        
          
          child: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                child: BottomNavigationBar(backgroundColor: Colors.transparent, items: [
                  BottomNavigationBarItem(title: Text('data'), icon: Icon(Icons.link)),
                  BottomNavigationBarItem(title: Text('data'), icon: Icon(Icons.link)),
                  BottomNavigationBarItem(title: Text('data'), icon: Icon(Icons.link)),
                ]),
              ),
            ],
          ),
        
      ),
    );
  }
}
