import 'package:ca_cop/stringComparison/word_pair.dart';
import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  const Question({
    Key key,
    @required this.words,
  }) : super(key: key);

  final WordPair words;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '${this.words.word1}',
          style: textStyle,
        ),
        Text(
          '${this.words.word2}',
          style: textStyle,
        ),
      ],
    );
  }
}
