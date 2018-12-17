import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';
import 'config.dart';
import 'blocs/database_helper.dart';

import 'package:hawalnir1/wordpress_client.dart';
import 'blocs/functions.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = 'http://ehawal.com/index.php/wp-json';

var dbHelper = DatabaseHelper();
int perPageInt = int.parse(perPage);

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

class HawalnirHome2State extends State {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: Scaffold(
        drawer: drawerMain(context),
        appBar: AppBar(
            title: Text("app 2"), //TODO edit this
            backgroundColor: Colors.blueAccent),
        body: RefreshIndicator(
          onRefresh: isExitst,
          child: FutureBuilder<List<Post>>(
              future: isExitst(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? ListViewPosts2(posts: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              }),
        ),
        floatingActionButton:
            FloatingActionButton(child: Text('UP'), onPressed: _scrollToTop),
      ),
    );
  }
}

void _scrollToTop() {
  scrollCont.animateTo(0.0,
      duration: Duration(seconds: 1), curve: Curves.elasticInOut);
}
