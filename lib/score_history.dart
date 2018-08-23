import 'package:flutter/material.dart';

class ScoreData {
  final int score;
  final DateTime timestamp;
  ScoreData(this.score, this.timestamp);

  @override
  String toString() => '($timestamp, $score})';
}

class History extends StatelessWidget {
  const History({
    Key key,
    @required this.scoreHistory,
  }) : super(key: key);

  final List<ScoreData> scoreHistory;

  @override
  Widget build(BuildContext context) {
    List<Widget> wg = scoreHistory
        .map((e) => ListTile(
              title: Text('${e}'),
            ))
        .toList();
    return ListBody(
      children: wg,
    );
  }
}
