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
            floatingActionButton: FloatingActionButton(
                isExtended: false,

                elevation: 10.0,
                shape: CircleBorder(),
                child: Icon(Icons.arrow_drop_up),
                onPressed: _scrollToTop),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            resizeToAvoidBottomPadding: true,

            bottomNavigationBar:
            SizedBox(
              height: 80,
              child: BottomAppBar(
                color: Colors.cyanAccent,
                notchMargin: 5.0,
                shape: CircularNotchedRectangle(),
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.save),
                      splashColor: Colors.blueAccent[200],
                      color: Colors.blueGrey,
                      tooltip: 'پاشكه‌وت كردنی بابه‌ت',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/InstaPage');
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.favorite),
                      splashColor: Colors.redAccent,
                      color: Colors.blueGrey,
                      tooltip: 'په‌سه‌ند كردن',
                      onPressed: () {}, // add +1 to the database
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.blueGrey,
                      tooltip: 'بو هاورێكانت بنێره‌',
                      onPressed:
                          () {}, // Standard share for whatsapp + google + faccebook + twitter
                    ),
                  ],
                ),
              ),
            )));
  }


  void _scrollToTop() {
    scrollCont.animateTo(0.0,
        duration: Duration(seconds: 1), curve: Curves.elasticInOut);
  }
}