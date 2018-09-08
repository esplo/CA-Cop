import 'dart:math';

import 'package:ca_cop/iconRecollection/icon_grid.dart';
import 'package:ca_cop/ui/timer_display.dart';
import 'package:flutter/material.dart';

class IconRecollection extends StatefulWidget {
  final String title;
  final int seed;

  final Random rng;

  IconRecollection({
    Key key,
    @required this.title,
    @required this.seed,
  })  : rng = new Random(seed),
        super(key: key);

  @override
  _IconRecollectionState createState() => _IconRecollectionState();

  final int GRID_COUNT = 25;
  final int ICON_COUNT = 10;
  final List<IconData> iconData = const [
    Icons.add,
    Icons.access_time,
    Icons.accessibility,
    Icons.adjust,
    Icons.airplanemode_active,
    Icons.all_inclusive,
    Icons.android,
    Icons.arrow_downward,
    Icons.attachment,
    Icons.build,
    Icons.call,
    Icons.check,
    Icons.clear,
    Icons.create,
    Icons.delete,
    Icons.drive_eta,
    Icons.favorite,
    Icons.headset,
    Icons.language,
    Icons.local_dining,
  ];
}

class _IconRecollectionState extends State<IconRecollection> {
  List<IconData> icons = [];

  @override
  void initState() {
    super.initState();
    icons = [];

    // TODO:
    _startSession();
  }

  void _startSession() {
    setState(() {
      icons =
          makeIconsWithPadding(widget.GRID_COUNT, pickIcons(widget.ICON_COUNT));
    });
  }

  List<IconData> makeIconsWithPadding(int n, List<IconData> icons) {
    assert(n >= icons.length);
    final int origLen = icons.length;
    for (var i = 0; i < n - origLen; i++) {
      icons.add(null);
    }
    icons.shuffle(widget.rng);

    return icons;
  }

  List<IconData> pickIcons(int n) {
    icons = new List<IconData>.from(widget.iconData)..shuffle(widget.rng);
    return icons.take(n).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(
              remainingTime: 10,
            ),
            IconGrid(iconData: icons),
          ],
        ),
      ),
    );
  }
}
