class ScoreData {
  final String version;
  final int score;
  final DateTime timestamp;

  ScoreData(this.version, this.score, this.timestamp);

  @override
  String toString() => '($score, $timestamp, v$version)';
}
