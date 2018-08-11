import 'package:ca_cop/word_pair.dart';
import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  const Question({
    Key key,
    @required this.words,
  }) : super(key: key);

  final WordPair words;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('${this.words.word1}'),
      Text('${this.words.word2}'),
    ]);
  }
}
