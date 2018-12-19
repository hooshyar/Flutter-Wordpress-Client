import 'package:flutter/material.dart';
import 'package:hawalnir1/src/widgets/eachPost.dart';
import 'package:http/http.dart' as http;
import 'widgets/drawerMain.dart';
import 'config.dart';
import 'blocs/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:hawalnir1/wordpress_client.dart';
import 'blocs/functions.dart';
import 'widgets/catWidgets.dart';
import 'package:flutter_offline/flutter_offline.dart';

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
    return Scaffold(
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

                  RefreshIndicator(
                    onRefresh: isExitst,
                    child: FutureBuilder<List<Post>>(
                      future: isExitst(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ? ListViewPosts2(posts: snapshot.data)
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
                      color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                      child: Center(
                        child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                      ),
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

class ListViewPosts2 extends StatefulWidget {
  final List<Post> posts;

  ListViewPosts2({Key key, this.posts}) : super(key: key);

  @override
  ListViewPosts2State createState() {
    return new ListViewPosts2State();
  }
}

var scrollCont =
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

class ListViewPosts2State extends State<ListViewPosts2> {
  var dbHelper = DatabaseHelper();
  List<Post> postList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    getPostsIDs();
    return Directionality(
      textDirection: TextDirection.rtl, // RTL

      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                sliverAppBarGlobal(),
                sliverListGlobal(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//    return OfflineBuilder(
//      debounceDuration: Duration(seconds: 3),
//      connectivityBuilder: (
//        BuildContext context,
//        ConnectivityResult connectivity,
//        Widget child,
//      ) {
//        final bool connected = connectivity != ConnectivityResult.none;
//        return new Stack(
//          fit: StackFit.expand,
//          children: [
//            ListView.builder(
//                controller: scrollCont,
//                itemCount: posts.length, //posts.length,
//                padding: const EdgeInsets.all(15.0),
//                itemBuilder: (context, position) {
//                  int postID = posts[position].id;
//                  return Card(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                    clipBehavior: Clip.hardEdge,
//                    child: Column(
//
//                      children: <Widget>[
//                        Stack(
//                          children: <Widget>[
//                            Hero(
//
//                                tag: 'hero$postID',
//                                child: hawalImage(posts[position])),
//                            Positioned(
//                              bottom: 2.0,
//                              left: 5.0,
//                              child: new ButtonTheme.bar(
//                                child: hawalBtnBar(),
//                              ),
//                            ),
//                          ],
//                        ),
//                        new Padding(
//                          padding: EdgeInsets.all(5.0),
//                          child: new ListTile(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  //fullscreenDialog: true,
//                                  builder: (context) =>
//                                      HawalnirPost(post: posts[position]),
//                                ),
//                              );
//                            },
//
//                            title: hawalTitle(posts[position]),
//                            subtitle: Row(
//                              children: <Widget>[
//                                Expanded(child: hawalAuthor(posts[position])),
//                                Expanded(
//                                  child: hawalDate(posts[position]),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//
//                      ],
//                    ),
//                  );
//                }),
//            Positioned(
//              height: 24.0,
//              left: 0.0,
//              right: 0.0,
//              child: Container(
//                color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
//                child: Center(
//                  child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
//                ),
//              ),
//            ),
//          ],
//        );
//      },
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          new Text(
//            'There are no bottons to push :)',
//          ),
//          new Text(
//            'Just turn off your internet.',
//          ),
//        ],
//      ),
//    );

void _scrollToTop() {
  scrollCont.animateTo(0.0,
      duration: Duration(seconds: 1), curve: Curves.elasticInOut);
}

//        child: CustomScrollView(
//          slivers: <Widget>[
//            SliverAppBar(
//                floating: true,
//                pinned: false,
//                expandedHeight: 120.0,
//                flexibleSpace: FlexibleSpaceBar(
//                  title: Text('Slivers'),
//                ),
//                leading: IconButton(
//                  icon: Icon(Icons.arrow_drop_up),
//                  onPressed: () {},
//                )
//            ),

//          SliverGrid(
//            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//              maxCrossAxisExtent: 200.0,
//              mainAxisSpacing: 10.0,
//              crossAxisSpacing: 10.0,
//              childAspectRatio: 4.0,
//            ),
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                return Container(
//                  alignment: Alignment.center,
//                  color: Colors.teal[100 * (index % 9)],
//                  child: Text('grid item $index'),
//                );
//              },
//              childCount: 20,
//            ),
//          ),
//            SliverFixedExtentList(
//              itemExtent: 50.0,
//              delegate: SliverChildBuilderDelegate(
//                    (BuildContext context, int index) {
//                  return Container(
//                    alignment: Alignment.center,
//                    color: Colors.lightBlue[100 * (index % 9)],
//                    child: Text('list item $index'),
//                  );
//                },
//              ),
//            ),

//      CupertinoSliverRefreshControl(
//              onRefresh: isExitst,
//               refreshIndicatorExtent: 30.0,
//               refreshTriggerPullDistance: 30.0,
//
//               builder: ,
////                 future: isExitst(),
////                  builder: (context, snapshot) {
////                    if (snapshot.hasError) print(snapshot.error);
////
////                    return snapshot.hasData
////                        ? ListViewPosts2(posts: snapshot.data)
////                        : Center(child: CircularProgressIndicator());
////                  },
//
//            ),
//

//
//
//          ],
//        ),
//      ),
//
//    );

//    return Directionality(
//        textDirection: TextDirection.rtl, // RTL
//        child: Scaffold(
//            drawer: drawerMain(context),
//          body: CupertinoSliverNavigationBar(
//            automaticallyImplyLeading: true,
//            automaticallyImplyTitle: true,
//            backgroundColor: Colors.deepPurple ,
//            largeTitle: Text('Hawalnir'),
//          ),
//appBar: CupertinoNavigationBar(
//  backgroundColor: Colors.deepPurple.withOpacity(0.5) ,
//  middle: Text("Hawalnir"),
//
//),
//            appBar: AppBar(
//                title: Text("app 2"), //TODO edit this
//                backgroundColor: Colors.blueAccent),
//            body:
//            RefreshIndicator(
//              onRefresh: isExitst,
//              child: FutureBuilder<List<Post>>(
//                  future: isExitst(),
//                  builder: (context, snapshot) {
//                    if (snapshot.hasError) print(snapshot.error);
//
//                    return snapshot.hasData
//                        ? ListViewPosts2(posts: snapshot.data)
//                        : Center(child: CircularProgressIndicator());
//                  },
//              ),
//            ),

//  }

//            floatingActionButton: FloatingActionButton(
//                isExtended: false,
//
//                elevation: 10.0,
//                shape: CircleBorder(),
//                child: Icon(Icons.arrow_drop_up),
//                onPressed: _scrollToTop),
//            floatingActionButtonLocation:
//            FloatingActionButtonLocation.endDocked,
//            resizeToAvoidBottomPadding: true,
//
//            bottomNavigationBar:
//
//            SizedBox(
//              height: 60,
//              child:
//              BottomAppBar(
//                color: Colors.deepPurple,
//                notchMargin: 5.0,
//                shape: CircularNotchedRectangle(),
//                child: ButtonBar(
//                  mainAxisSize: MainAxisSize.max,
//                  alignment: MainAxisAlignment.spaceEvenly ,
//                  children: <Widget>[
//                    IconButton(
//                      padding: EdgeInsets.only(bottom: 10.0),
//
//                      icon: Icon(Icons.save),
//                      splashColor: Colors.blueAccent[200],
//                      color: Colors.blueGrey,
//                      tooltip: 'پاشكه‌وت كردنی بابه‌ت',
//                      onPressed: () {
//                        Navigator.pushNamed(
//                            context, '/InstaPage');
//                      },
//                    ),
//
//                    IconButton(
//                      padding: EdgeInsets.only(bottom: 10.0),
//                      icon: Icon(Icons.favorite),
//                      splashColor: Colors.redAccent,
//                      color: Colors.blueGrey,
//                      tooltip: 'په‌سه‌ند كردن',
//                      onPressed: () {}, // add +1 to the database
//                    ),
//                    IconButton(
//                      padding: EdgeInsets.only(bottom: 10.0),
//
//                      icon: Icon(Icons.share),
//                      color: Colors.blueGrey,
//                      tooltip: 'بو هاورێكانت بنێره‌',
//                      onPressed:
//                          () {}, // Standard share for whatsapp + google + faccebook + twitter
//                    ),
//                    Divider(
//                    ) ,
//                  ],
//                ),
//              ),
//            ),
//        ),
//    );
//  }
