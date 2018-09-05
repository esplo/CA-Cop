import 'package:flutter/material.dart';

class MeasurementCard extends StatelessWidget {
  final int seed;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;

  MeasurementCard({
    Key key,
    @required this.seed,
    @required this.title,
    @required this.subtitle,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.album),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('START'),
                  onPressed: () {
                    print(builder);
                    Navigator.push(
                        context, new MaterialPageRoute<void>(builder: builder));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
