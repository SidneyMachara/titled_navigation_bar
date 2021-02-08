import 'package:flutter/material.dart';

class TitledNavigationBarItem {
  // Widget title;
  final Widget icon;
  final Color backgroundColor;

  TitledNavigationBarItem({
    @required this.icon,
    this.backgroundColor = Colors.white,
  });
}
