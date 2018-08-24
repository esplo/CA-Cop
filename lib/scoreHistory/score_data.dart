class ScoreData {
  final int score;
  final DateTime timestamp;

  ScoreData(this.score, this.timestamp);

  @override
  String toString() => '($timestamp, $score)';
}
