import 'package:flutter/material.dart';

class AnswerButtons extends StatelessWidget {
  const AnswerButtons({
    Key key,
    @required this.nextQuestion,
  }) : super(key: key);

  final Function nextQuestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: () => nextQuestion(true),
            child: Text('same'),
          ),
        ),
        Expanded(
          child: RaisedButton(
            onPressed: () => nextQuestion(false),
            child: Text('different'),
          ),
        ),
      ],
    );
  }
}
