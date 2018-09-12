import 'dart:math';

import 'package:ca_cop/iconRecollection/icon_grid.dart';
import 'package:ca_cop/ui/timer_display.dart';
import 'package:flutter/material.dart';

class IconRecollection extends StatefulWidget {
  final String title;

  final Random rng;

  IconRecollection({
    Key key,
    @required this.title,
    @required seed,
  })  : rng = new Random(seed ?? DateTime.now().millisecondsSinceEpoch),
        super(key: key);

  @override
  _IconRecollectionState createState() => _IconRecollectionState();

  final int GRID_ROW = 5;
  final int GRID_COLUMN = 5;
  final int ICON_COUNT = 15;
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
      icons = makeIconsWithPadding(
          widget.GRID_ROW, widget.GRID_COLUMN, pickIcons(widget.ICON_COUNT));
    });
  }

  List<IconData> makeIconsWithPadding(int n, int m, List<IconData> icons) {
    assert(n * m >= icons.length);
    assert(n + m <= icons.length);
    assert(n > 1); // to avoid an infinite loop in the balanced-placement
    assert(m > 1);

    final List<IconData> res = List.filled(n * m, null);

    // well balanced
    // horizontal
    for (var i = 0; i < m; i++) {
      final int u = widget.rng.nextInt(n);
      res[u * m + i] = icons[i];
    }

    // vertical
    for (var i = 0; i < n; i++) {
      final int u = widget.rng.nextInt(m);
      final int t = u + n * i;
      if (res[t] != null) {
        i--;
        continue;
      }
      res[t] = icons[m + i];
    }

    return res;
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
            IconGrid(column: widget.GRID_COLUMN, iconData: icons),
          ],
        ),
      ),
    );
  }
}
