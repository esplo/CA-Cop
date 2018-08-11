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
        Text('score: '),
        Text('${this.score}'),
      ],
    );
  }
}
