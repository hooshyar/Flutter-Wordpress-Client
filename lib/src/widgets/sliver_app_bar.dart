import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hawalnir1/src/view_models/app_key.dart';
import 'package:provider/provider.dart' as provider;

import '../pages/listView.dart';

class SliverAppBarCustomized extends StatelessWidget {
  const SliverAppBarCustomized({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: true,
      expandedHeight: 60.0,
      leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () => provider.Provider.of<Keys>(context, listen: false)
              .appScaffoldKey
              .currentState
              .openDrawer()),
      flexibleSpace: Stack(
        children: <Widget>[
          Container(
            color: Colors.deepPurple.withOpacity(0.7),
          ),
          FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            title: GestureDetector(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Text(
                  'Flutter-Wordpress-Client',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              onTap: scrollToTop,
            ),
          ),
        ],
      ),
    );
  }
}
