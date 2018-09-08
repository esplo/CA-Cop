class AnswerHistory {
  final Duration time;
  final bool isSame;
  final int score;

  AnswerHistory(this.time, this.isSame, this.score);

  @override
  String toString() => '($time, ${isSame ? 'same' : 'different'}, $score)';
}
