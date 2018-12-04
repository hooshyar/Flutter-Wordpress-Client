import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import '../widgets/catWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../config.dart';
import 'package:hawalnir1/wordpress_client.dart';
import '../app2.dart';
import '../client.dart';
import 'package:cached_network_image/cached_network_image.dart';

List posts;

class ListViewPosts2 extends StatelessWidget {
  final List<Post> posts;
  final List<User> users;
  final List<Media> medias;
  ListViewPosts2({Key key, this.posts, this.users, this.medias})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Text(postsFrom.toString(),

    return Directionality(
        textDirection: TextDirection.rtl, // RTL
        child: Scaffold(
            body: RefreshIndicator(
                onRefresh: client.listPosts,
                child: ListView.builder(
                    itemCount: posts.length,
                    padding: const EdgeInsets.all(15.0),
                    itemBuilder: (context, position) {
                      int usersCount = users.length;
                      int mediasCount = medias.length;
                      String authorName = posts[position].authorName;

                      debugPrint(authorName);
                      dynamic imgUrl = posts[position].featuredMediaUrl;
                      debugPrint(imgUrl.toString());

                      int userId = posts[position].author;
                      // int  imgLength ; imgUrl2.length ;
                      //debugPrint(imgLength.toString()) ;

                      return Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: CachedNetworkImage(
                                fadeInCurve: Curves.decelerate,
                                repeat: ImageRepeat.noRepeat,
                                fadeInDuration: Duration(seconds: 5),
                                imageUrl: imgUrl == null
                                    ? 'assets/images/placeholder.png'
                                    : imgUrl,
                                placeholder: Image.asset(
                                    'assets/images/placeholder.png'),
                                errorWidget: new Icon(Icons.error),
                              ),

                              /*
                              child: FadeInImage.assetNetwork(

                                placeholder: 'assets/images/placeholder.png',
                                image: imgUrl == null
                                    ? 'assets/images/placeholder.png'
                                    : imgUrl,
                              ),

                              */
                            ),
                            new Padding(
                              padding: EdgeInsets.all(5.0),
                              child: new ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) =>
                                          HawalnirPost(post: posts[position]),
                                    ),
                                  );
                                },

                                title: Text('${posts[position].title}'),

                                //hawalTitle(posts, index),

                                subtitle: new Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(authorName.toString())),
                                    Expanded(
                                      child: hawalDate(posts[position]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new ButtonTheme.bar(
                              child: hawalBtnBar(),
                            ),
                          ],
                        ),
                      );
                    }))));
  }
}
