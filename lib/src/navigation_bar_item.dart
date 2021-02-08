import 'package:flutter/material.dart';

class TitledNavigationBarItem {
  Widget title;
  final Widget icon;
  final Color backgroundColor;

  TitledNavigationBarItem({
    @required this.icon,
    this.title,
    this.backgroundColor = Colors.white,
  }) {
    if (title == null) {
      this.title = icon;
    }
  }
}
