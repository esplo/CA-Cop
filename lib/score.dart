import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  const Score({
    Key key,
    @required this.score,
  }) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('SCORE: '),
        Text(
          '${this.score}',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: getColor(this.score),
          ),
        ),
      ],
    );
  }

  Color getColor(int score) {
    if (score == 0) {
      return Colors.black;
    } else if (score > 0) {
      return Colors.lightBlue;
    } else {
      return Colors.pinkAccent;
    }
  }
}
