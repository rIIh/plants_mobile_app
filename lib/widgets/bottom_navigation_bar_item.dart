import 'package:flutter/material.dart';

class UntitledBottomNavigationBarItem extends BottomNavigationBarItem {
  UntitledBottomNavigationBarItem({
    Widget icon,
    Widget activeIcon,
    Color backgroundColor,
  }) : super(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: icon,
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: activeIcon ?? icon,
          ),
          backgroundColor: backgroundColor,
          title: const Text(''),
        );
}
