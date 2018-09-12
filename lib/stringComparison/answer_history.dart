class AnswerHistory {
  final Duration time;
  final bool isSame;
  final int score;
  final String word1, word2;

  AnswerHistory(this.time, this.isSame, this.score, this.word1, this.word2);

  @override
  String toString() =>
      '($time, ${isSame ? 'same' : 'different'}, $score, $word1-$word2)';

  String pretty() =>
      '[${time.inSeconds}.${time.inMilliseconds}s] $score, ${isSame ? 'same' : 'different'}, ($word1 $word2)';
}
