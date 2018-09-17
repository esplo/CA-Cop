class AnswerHistory {
  final int score;
  final int pos1, pos2;

  AnswerHistory(this.score, this.pos1, this.pos2);

  @override
  String toString() => '($score, $pos1-$pos2)';

  String pretty() => '$score, ($pos1 $pos2)';
}
