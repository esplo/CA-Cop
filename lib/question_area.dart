import 'package:ca_cop/answer_buttons.dart';
import 'package:ca_cop/question.dart';
import 'package:ca_cop/timer_display.dart';
import 'package:ca_cop/word_pair.dart';
import 'package:flutter/material.dart';

class QuestionArea extends StatelessWidget {
  const QuestionArea({
    Key key,
    @required this.currentWordPair,
    @required this.remainingTime,
    @required this.nextQuestion,
  }) : super(key: key);

  final WordPair currentWordPair;
  final int remainingTime;
  final Function nextQuestion;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TimerDisplay(remainingTime: remainingTime),
          Question(words: currentWordPair),
          AnswerButtons(
            nextQuestion: nextQuestion,
          ),
        ],
      ),
    );
  }
}
