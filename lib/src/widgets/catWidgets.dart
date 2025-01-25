import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hawalnir1/src/widgets/posts_card.dart';

import '../../wordpress_client.dart';
import '../config.dart';
import 'hawalnir-date-convertor.dart';
import '../models/post.dart';
import '../models/category.dart';

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
                offset: const Offset(1.0, 1.0),
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
              stops: const [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black45,
                Colors.black87,
              ],
            )),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: CachedNetworkImage(
            fadeInCurve: Curves.decelerate,
            repeat: ImageRepeat.noRepeat,
            fadeInDuration: const Duration(milliseconds: 500),
            imageUrl: post.featuredMediaUrl?.toString() ??
                'https://via.placeholder.com/300x150.png',
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png'),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    ],
  );
}

Widget hawalTitle(Post post) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 800),
    child: Text(post.title.rendered,
        style: const TextStyle(
          fontSize: 20,
        )),
  );
}

Widget hawalAuthor(Post post) {
  return Text(
    "author: ${post.author ?? 'Unknown'}",
    textAlign: TextAlign.right,
  );
}

Widget hawalDate(Post post) {
  return Text(
    dateConvertor(post.date?.toString() ?? ''),
    textAlign: TextAlign.left,
  );
}

Widget hawalBtnBar() {
  return OverflowBar(
    children: <Widget>[
      IconButton(
        icon: const Icon(Icons.save),
        splashColor: Colors.blueAccent[200],
        color: Colors.blueGrey,
        tooltip: 'save',
        onPressed: () {
          debugPrint("save button tapped");
        },
      ),
      IconButton(
        icon: const Icon(Icons.favorite),
        splashColor: Colors.redAccent,
        color: Colors.blueGrey,
        tooltip: 'like',
        onPressed: () {
          debugPrint("favorite button tapped");
        },
      ),
      IconButton(
        icon: const Icon(Icons.share),
        color: Colors.blueGrey,
        tooltip: 'share',
        onPressed: () {
          debugPrint("share button tapped");
        },
      ),
    ],
  );
}

Widget connectionErrorBar() {
  return Container(
    alignment: Alignment.bottomCenter,
    child: SnackBar(
      duration: const Duration(milliseconds: 200),
      content: Text(connectionError),
    ),
  );
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

Widget sliverListGlobal(List<Post> posts) {
  debugPrint('SliverListGlobal received ${posts.length}');
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, index) {
        return PostsCard(
          post: posts[index],
        );
      },
      childCount: posts.length,
      addAutomaticKeepAlives: true,
    ),
  );
}

Widget nameRendered(Category category) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 800),
    child: Html(
      data: category.name ?? '',
      style: {
        "*": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(20),
          textAlign: TextAlign.start,
          width: Width(100, Unit.percent),
        ),
      },
      shrinkWrap: true,
    ),
  );
}
