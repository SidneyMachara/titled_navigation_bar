import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'navigation_bar_item.dart';

// ignore: must_be_immutable
class TitledBottomNavigationBar extends StatefulWidget {
  final Curve curve;
  final Color activeColor;
  final Color inactiveColor;
  final Color inactiveStripColor;
  final Color indicatorColor;
  final bool enableShadow;
  int currentIndex;
  final ValueChanged<int> onTap;
  final List<TitledNavigationBarItem> items;

  TitledBottomNavigationBar({
    Key key,
    this.curve = Curves.linear,
    @required this.onTap,
    @required this.items,
    this.activeColor,
    this.inactiveColor,
    this.inactiveStripColor,
    this.indicatorColor,
    this.enableShadow = true,
    this.currentIndex = 0,
  })  : assert(items != null),
        assert(items.length >= 2 && items.length <= 5),
        assert(onTap != null),
        assert(currentIndex != null),
        assert(enableShadow != null),
        super(key: key);

  @override
  State createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar> {
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 2;

  Curve get curve => widget.curve;

  List<TitledNavigationBarItem> get items => widget.items;

  double width = 0;
  Color activeColor;
  Duration duration = Duration(milliseconds: 270);

  double _getIndicatorPosition(int index) {
    var isLtr = Directionality.of(context) == TextDirection.ltr;
    if (isLtr)
      return lerpDouble(-1.0, 1.0, index / (items.length - 1));
    else
      return lerpDouble(1.0, -1.0, index / (items.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      height: BAR_HEIGHT + MediaQuery.of(context).viewPadding.bottom,
      width: width,
      decoration: BoxDecoration(
        color: widget.inactiveStripColor ?? Theme.of(context).cardColor,
        boxShadow: widget.enableShadow
            ? [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ]
            : null,
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => _select(index),
                  child: _buildItemWidget(item, index == widget.currentIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment:
                  Alignment(_getIndicatorPosition(widget.currentIndex), 0),
              curve: curve,
              duration: duration,
              child: Container(
                color: widget.indicatorColor ?? activeColor,
                width: width / items.length,
                height: INDICATOR_HEIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _select(int index) {
    widget.currentIndex = index;
    widget.onTap(widget.currentIndex);

    /// commenting this out cause the scafold using this will most likey refresh everything inculding this widget
    // setState(() {});
  }

  Widget _buildIcon(TitledNavigationBarItem item, Color color) {
    return IconTheme(child: item.icon, data: IconThemeData(color: color));
  }

  Widget _buildItemWidget(TitledNavigationBarItem item, bool isSelected) {
    return Container(
      color: item.backgroundColor,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          _buildIcon(
            item,
            isSelected ? activeColor : widget.inactiveColor,
          ),
          // AnimatedOpacity(
          //   opacity: isSelected ? 0.0 : 1.0,
          //   duration: duration,
          //   curve: curve,
          //   child: _buildIcon(
          //     item,
          //     isSelected ? activeColor : widget.inactiveColor,
          //   ),
          // ),
          // AnimatedAlign(
          //   duration: duration,
          //   alignment: isSelected ? Alignment.center : Alignment(0, 5.2),
          //   child: _buildIcon(
          //     item,
          //     isSelected ? activeColor : widget.inactiveColor,
          //   ),
          // ),
        ],
      ),
    );
  }
}
