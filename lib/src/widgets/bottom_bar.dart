import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
}
);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    /// Yes - He is using CupertinoTabBar on both Android and iOS. It looks dope.
    /// I'm not a designer either, and only God can judge us. (╯°□°）╯︵ ┻━┻
    return CupertinoTabBar(
      backgroundColor: Colors.black54,
      inactiveColor: Colors.white54,
      activeColor: Colors.white,
      iconSize: 24.0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}