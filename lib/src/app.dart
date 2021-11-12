import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;

import '../wordpress_client.dart';
import 'config.dart';
import 'pages/listView.dart';
import 'view_models/app_key.dart';
import 'widgets/drawerMain.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = mainApiUrl;

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
      key: provider.Provider.of<Keys>(context, listen: false).appScaffoldKey,
      drawer: DrawerMain(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: true,
      body: Stack(fit: StackFit.expand, children: [
        Container(
          child: FutureBuilder<List<Post>>(
            future: client.listPosts(page: 3, perPage: 4),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? ListViewPosts(posts: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ]),
    );
  }

  bottomNavAppBar() {
    return ClipRect(
      child: Container(
        height: 80,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                        label: 'Home', icon: Icon(Icons.home)),
                    BottomNavigationBarItem(
                        label: 'Favorites', icon: Icon(Icons.favorite)),
                    BottomNavigationBarItem(
                        label: 'gallery', icon: Icon(Icons.image)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
