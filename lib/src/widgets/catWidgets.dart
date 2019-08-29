import 'package:flutter/material.dart';
import '../../src/db/functions.dart';
import '../../src/widgets/eachPost.dart';
import 'hawalnir-date-convertor.dart';
import '../config.dart';
import '../../wordpress_client.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/listView.dart';

Widget hawalImage(Post post) {
  return Stack(
    children: <Widget>[
      Positioned(
        bottom: 5.0,
        right: 0,
        left: 0,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 10,
                blurRadius: 20,
                color: Colors.black,
                offset: new Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ),
      Container(
        foregroundDecoration: BoxDecoration(
            backgroundBlendMode: BlendMode.overlay,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.

                Colors.transparent,
                Colors.transparent,
                Colors.black45,
                Colors.black87,
              ],
            )),
        child: CachedNetworkImage(
//          width: 200.0,
          fadeInCurve: Curves.decelerate,
          repeat: ImageRepeat.noRepeat,
          fadeInDuration: Duration(milliseconds: 500),
          imageUrl: post.featuredMediaUrl == null
              ? 'assets/images/placeholder.png'
              : post.featuredMediaUrl,
          placeholder: (context, url) =>
              Image.asset('assets/images/placeholder.png'),
          // placeholder: Image.asset('assets/images/placeholder.png'),
          errorWidget: (context, url, error) => Container(
            child: Icon(Icons.error),
          ),
        ),
      ),
    ],
  );
}

Widget hawalTitle(Post post) {
  return // Text("data")
      Html(
          data: post.title,
          defaultTextStyle: TextStyle(
              //fontFamily: 'NotoKufiArabic',
              fontSize: 20.0,
              decoration: TextDecoration.none));
}

Widget hawalAuthor(Post post) {
  return Text(
    "author: " + post.author,
    textAlign: TextAlign.right,
  );
}

Widget hawalDate(Post post) {
  return Text(
    dateConvertor(post.date.toString()),
    textAlign: TextAlign.left,
  );
}

Widget hawalBtnBar() {
  return ButtonBar(
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.save),
        splashColor: Colors.blueAccent[200],
        color: Colors.blueGrey,
        tooltip: 'save',
        onPressed: () {
          debugPrint("save button tapped");
        }, // add +1 to the database
      ),
      IconButton(
        icon: Icon(Icons.favorite),
        splashColor: Colors.redAccent,
        color: Colors.blueGrey,
        tooltip: 'like',
        onPressed: () {
          debugPrint("favorite button tapped");
        }, // add +1 to the database
      ),
      IconButton(
        icon: Icon(Icons.share),
        color: Colors.blueGrey,
        tooltip: 'share',
        onPressed: () {
          debugPrint("share button tapped");
        }, // Standard share for whatsapp + google + faccebook + twitter
      ),
    ],
  );
}

Widget connectionErrorBar() {
  return Container(
    alignment: Alignment.bottomCenter,
    child: SnackBar(
      duration: Duration(milliseconds: 200),
      animation: kAlwaysCompleteAnimation,
      content: Text(connectionProblemError),
    ),
  );
}

//Global Cards for Posts
postsCardGlobal(int index, context) {
  int postID = posts[index].id;
  return Card(
//                      color: Colors.teal[100 * (index % 9)] ,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    clipBehavior: Clip.hardEdge,
    child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Hero(tag: 'hero$postID', child: hawalImage(posts[index])),
            Positioned(
              bottom: 2.0,
              left: 5.0,
              child: new ButtonTheme.bar(
                child: hawalBtnBar(),
              ),
            ),
          ],
        ),
        new Padding(
          padding: EdgeInsets.all(5.0),
          child: new ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //fullscreenDialog: true,
                  builder: (context) => HawalnirPost(post: posts[index]),
                ),
              );
            },
            title: hawalTitle(posts[index]),
            subtitle: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                hawalAuthor(posts[index]),
                hawalDate(posts[index]),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// This is the type used by the popup menu below.
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

sliverAppBarGlobal() {
  return SliverAppBar(
    backgroundColor: Colors.deepPurple,
    pinned: true,
    expandedHeight: 70.0,
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      title: GestureDetector(
        child: Text('WPFlutter'),
        onTap: scrollToTop,
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.add_circle),
        tooltip: 'Add new entry',
        onPressed: () {},
      ),
    ],
  );
}

sliverListGlobal(List<Post> posts) {
  return SliverList(
//                itemExtent: 600.0,
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, index) {
        return postsCardGlobal(index, context);
//            return Container(
//              alignment: Alignment.center,
//              color: Colors.lightBlue[100 * (index % 9)],
//              child: Text('list item $index'),
//            );
      },
      childCount: posts.length,
      addAutomaticKeepAlives: true,
    ),
  );
}
