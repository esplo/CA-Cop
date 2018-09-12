import 'package:flutter/material.dart';

class IconGrid extends StatelessWidget {
  final int column;
  final List<IconData> iconData;

  IconGrid({
    Key key,
    @required this.column,
    @required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(iconData.length % column == 0);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: column,
      children: iconData.map((icon) {
        if (icon == null) {
          return Container();
        } else {
          return Center(
            child: Icon(icon),
          );
        }
      }).toList(),
    );
  }
}
