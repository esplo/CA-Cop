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
    final int row = iconData.length ~/ column;

    final Color borderColor = Color.fromARGB(30, 0, 0, 255);

    final List<Widget> cells = [];
    final Widget empty = Container(
      decoration: BoxDecoration(
        border: new Border.all(color: borderColor),
      ),
    );
    final makeHeader = (String i) => Container(
        child: Center(
          child: Text(
            i.toString(),
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
        ));
    final makeIcon = (IconData icon) => Container(
          child: Center(
            child: Icon(icon),
          ),
          decoration: BoxDecoration(
            border: new Border.all(color: borderColor),
          ),
        );

    cells.add(Container());
    for (var r = 0; r < row; r++) {
      cells.add(makeHeader(r.toString()));
    }
    for (var r = 0; r < row; r++) {
      for (var c = 0; c < column; c++) {
        if (c == 0) {
          cells.add(makeHeader(String.fromCharCode('A'.codeUnits.first + r)));
        }
        final int i = row * r + c;
        if (iconData[i] == null) {
          cells.add(empty);
        } else {
          cells.add(makeIcon(iconData[i]));
        }
      }
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: column + 1,
      children: cells,
    );
  }
}
