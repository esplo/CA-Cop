import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({
    Key key,
    @required this.remainingTime,
  }) : super(key: key);

  final int remainingTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.timer),
        Text('$remainingTime'),
      ],
    );
  }
}
