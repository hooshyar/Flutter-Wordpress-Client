import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert';
import 'widgets/catWidgets.dart';
import 'widgets/drawerMain.dart';
import 'widgets/listViews2.dart';
import 'config.dart';
//import 'blocs/item-model.dart';
import 'blocs/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'pages/no-net.dart';
//WPCLIENT_START
import 'package:hawalnir1/wordpress_client.dart';

WordpressClient client = new WordpressClient(_baseUrl, http.Client());
final String _baseUrl = 'http://ehawal.com/index.php/wp-json';
//WPCLIENT_END

var dbHelper = DatabaseHelper();
int perPageInt = int.parse(perPage);

class HawalnirHome2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HawalnirHome2State();
}

List<Post> cachedPosts;
List<Post> posts;
int dbCount;
bool netConnection = true ;


//Future<List<Post>> whichPosts() async {
//
//}
////  if (count <= 1) {
////    return getPosts();
////  } else {
////    return getPostsFromDB();
////  }
////}
//
//List<int> postsIDs = List();
//List<int> cachedPostsIDs = List();
//
//Future<List<Post>> getPosts() async {
//  posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
//  cachedPosts = await dbHelper.getPostList();
//  //debugPrint(cachedPosts.toString()) ;
//
//  debugPrint('from Wordpress API');
//  return posts;
//}

//Future<List<Post>> getPostsFromDB() async {
//  cachedPosts = await dbHelper.getPostList();
//  debugPrint('from DataBAse');
////  debugPrint(cachedPosts.toString());
//  posts = cachedPosts;
//  return posts;
//}
List<int> postsIDs = List();
List<int> cachedPostsIDs = List();

getCachedPostsIDs() {
  for (int i = 0; i < cachedPosts.length; i++) {
    cachedPostsIDs.add(cachedPosts[i].id);
  }
}

getPostsIDs() {
  for (int i = 0; i < posts.length; i++) {
    postsIDs.add(posts[i].id);
//    return postsIDs ;
  }
}

clearDB() async {
  int count = await dbHelper.getCount();

  debugPrint("count is :  " + count.toString());
  for (int i = 0; i < count; i++) {
    dbHelper.deletePost(cachedPosts[i].id);
    debugPrint("this post has been deleted" + (posts[i].id).toString());
    debugPrint("${cachedPosts[i].id} has been Deleted from  DB");
  }
}

fillDB() {
  for (int i = 0; i < posts.length; i++) {
    dbHelper.insertPost(posts[i]);
    debugPrint("${posts[i].id} has been inserted to DB");
  }
}

doWeHaveNet() async {
  //TODO POP something to know connection is lost
  int count = await dbHelper.getCount();
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      netConnection = true ;
//      return weHaveNet(HawalnirHome2State().context);
  return true ;



    }
  } on SocketException catch (_) {
    print('not connected');
    if (count < 1) {
      debugPrint('we need intenet');
    netConnection = false ;
      return false ;
    }
  }
  //TODO put a nice widget here for Connectivity problems
}




Future<List<Post>> isExitst() async {
  cachedPosts = await dbHelper.getPostList();

  if(doWeHaveNet() != true){
    debugPrint("doWeHaveNet() is != true ");
    posts = cachedPosts ;
    posts.sort((a, b) => b.id.compareTo(a.id));

  }else {
    debugPrint("doWeHaveNet() is == true ");
    posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
  }


  bool foundPost = true;
  getPostsIDs();
  getCachedPostsIDs();
  debugPrint('Posts Ids are: ' + postsIDs.toString());
  debugPrint('Cached pOsts ids are : ' + cachedPostsIDs.toString());

  if (cachedPosts.length < 1) {
    debugPrint('No Cached Posts Has Been FOUND');
    fillDB();
  } else {
    for (int i = 0; i < cachedPostsIDs.length; i++) {
      for (int j = 0; j < postsIDs.length; j++) {
        if (cachedPostsIDs.contains(postsIDs[j])) {
          debugPrint("FOUND ${postsIDs[j]} post in the database");
         foundPost = true;

        } else {
          foundPost = false;
          debugPrint("COULDNT FFIND ${postsIDs[j]} in cachedPostsIDs");
          break;
        }
      }

      if (foundPost == true) {
        for (int i = 0; i < posts.length; i++) {
          posts[i] = cachedPosts[i];
        }

        debugPrint('found post is TRUE ');
      } else {
        debugPrint('found post is NOT TRUE');
        posts = posts;
        await dbHelper.deleteDB();
        fillDB();
        debugPrint('DATABASE HAS BEEN DELETED');
      }
    }
  }
  posts.sort((a, b) => b.id.compareTo(a.id));
  return posts;
}

//TODO get all cached posts ids

//Todo get all new posts ids
//Todo Print both ids
//TODO show cached posts by default
//TODO compare posts[0] to cachedPosts ids , if found Update database
//TODO update listView

//
//
//
//Future<List<Post>> getPosts() async {
//  posts = await client.listPosts(perPage: perPageInt, injectObjects: true);
//  cachedPosts = await dbHelper.getPostList();
//
//  //debugPrint(cachedPosts.toString()) ;
//  debugPrint('from Wordpress API');
//  //from here
//  List<int> cachedPostsIds ;
//  for (int i = 0; i < 10; i++) {
//    cachedPostsIds[i] = cachedPosts[i].id;
//    debugPrint('cached Posts ids are ' + cachedPostsIds.toString());
//  }
//
//  if (cachedPosts[0].id == posts[0].id) {
//    debugPrint("cachedposts id  " + (cachedPosts[0].id).toString());
//    debugPrint("post id is  " + (posts[0].id).toString());
//
//
//
//    for (int j = 0; j < posts.length; j++) {
//      if (cachedPostsIds[j] == posts[0].id) {
//        debugPrint('post exxist');
//      }
//      //from here
//      cachedPosts = posts;
//    }
//  } else {
//    for (int i = 0; i < dbCount; i++) {
//      dbHelper.deletePost(cachedPosts[i].id);
//      debugPrint("this post has been deleted" + (posts[i].id).toString());
//    }
//
//    for (int i =0; i< perPageInt ; i++) {
//      dbHelper.insertPost(posts[i]);
//    }
//  }
//  debugPrint(cachedPostsIds.toString());
//  return posts;
//}

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
        body:

        RefreshIndicator(
          onRefresh: isExitst,
          child: FutureBuilder<List<Post>>(
              future: isExitst(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? ListViewPosts2(posts: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              }
          ),
          
        ),
        floatingActionButton: FloatingActionButton(
            child: Text('UP'),
            onPressed:  _scrollToTop
        ),

      ),
      
    );
    }
}

void _scrollToTop(){
  scrollCont.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.elasticInOut );
}

//
//
//// user defined function
//  void _showDialog() {
//    // flutter defined function
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Alert Dialog title"),
//          content: new Text("Alert Dialog body"),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }


//
//  Widget weHaveNet(context) {
//    return Directionality(
//      textDirection: TextDirection.rtl, // RTL
//      child: Scaffold(
//        drawer: drawerMain(context),
//        appBar: AppBar(
//            title: Text("app 2"), //TODO edit this
//            backgroundColor: Colors.blueAccent),
//        body: RefreshIndicator(
//          onRefresh: isExitst,
//          child: FutureBuilder<List<Post>>(
//            future: checkConnection(),
//            builder: (context, snapshot) {
//              if (snapshot.hasError) print('ErroR ');
//
//              return snapshot.hasData
//                  ? ListViewPosts2(posts: snapshot.data)
//                  : Center(child: CircularProgressIndicator());
//            },
//          ),
//        ),
//      ),
//    );
//  }
//}
//Widget weHaveNoNet(context) {
//
//    return AlertDialog(
//      title: new Text("Alert Dialog title"),
//      content: new Text("Alert Dialog body"),
//      actions: <Widget>[
//        // usually buttons at the bottom of the dialog
//        new FlatButton(
//          child: new Text("Close"),
//          onPressed: () {
//            if (netConnection = false) {
////                    Navigator.of(context).pop();
//
//
//              debugPrint('false');
//            } else {
//              Navigator.of(context, rootNavigator: true).pop('dialog');
//
//              // Navigator.of(context).pushNamed('/') ;
//              debugPrint("else");
//            }
//          },
//        ),
//      ],
//    );
//  }
//

//
//void _showDialog() {
//  // flutter defined function
//  showDialog(
//    context: context,
//    builder: (BuildContext context) {
//      // return object of type Dialog
//      return AlertDialog(
//        title: new Text("Alert Dialog title"),
//        content: new Text("Alert Dialog body"),
//        actions: <Widget>[
//          // usually buttons at the bottom of the dialog
//          new FlatButton(
//            child: new Text("Close"),
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//          ),
//        ],
//      );
//    },
//  );
//}

//
//class AlertPage extends StatelessWidget {
//  AlertPage({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Container(
//      child: RaisedButton(
//          onPressed: (){
//           // Navigator.pop(context);
//
////            Navigator.of(context).pop();
//          if(netConnection = true ){
//            Navigator.of(context).push(
//                new MaterialPageRoute(
//                    builder: (context) => new HawalnirHome2())
//            ) ;
//
//          }
//                  } ,
//          child: Text("dsdsd") ,
//      )
//
//    );
//  }
//}
//}