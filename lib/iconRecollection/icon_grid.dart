import 'package:flutter/material.dart';

class IconGrid extends StatelessWidget {
  final List<IconData> iconData;

  IconGrid({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(iconData.length == 25);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
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
