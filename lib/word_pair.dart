import 'dart:math';

import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

class WordPair {
  final word1, word2;

  WordPair(this.word1, this.word2);

  bool isEqual() => this.word1 == this.word2;

  @override
  String toString() => '($word1,$word2)';

  @override
  bool operator ==(o) => o is WordPair && o.word1 == word1 && o.word2 == word2;

  @override
  int get hashCode => hash2(word1.hashCode, word2.hashCode);
}

class WordPairGenerator {
  final minLength, maxLength, seed;
  Iterable<WordPair> _cache = <WordPair>[];

  WordPairGenerator({
    this.minLength = 3,
    this.maxLength = 8,
    @required this.seed,
  }) {
    next();
  }

  WordPair current() {
    return _cache.first;
  }

  void next() {
    if (_cache.isNotEmpty) _cache = _cache.skip(1);
    if (_cache.isEmpty) _cache = this.generate(this.seed, 20);
  }

  List<WordPair> generate(int seed, int count) {
    final rng = new Random(seed);
    return List<WordPair>.generate(
        count, (i) => makePair(rng, minLength, maxLength)).toList();
  }

  WordPair makePair(Random rng, int maxLength, int minLength) {
    final letters = letterSeed();
    final len = lengthPicker(rng, maxLength, minLength);
    final fs = stringCreator(len, rng, letters);
    final another = makeAnother(rng, fs, letters);
    return WordPair(fs, another);
  }

  String letterSeed() {
    final sb = new StringBuffer();
    final codes = new List<int>.generate(26, (i) => 'A'.codeUnitAt(0) + i);
    sb.write(String.fromCharCodes(codes));
    return sb.toString();
  }

// Two strings are considered to be identical when they have the same letters
// AFAIK, we cannot make different objects which have the same letters
  String makeClone(String str) {
    return str;
  }

// Chances are this function makes the same string
  String makeRandomClone(String str, int pos, String c) {
    final strList = str.split('');
    strList[pos] = c;
    final sb = new StringBuffer(strList.join());
    return sb.toString();
  }

  String makeAnother(Random rng, String fs, String letters) {
    final another = (rng.nextInt(2) == 0)
        ? makeRandomClone(
            fs, rng.nextInt(fs.length), letters[rng.nextInt(letters.length)])
        : makeClone(fs);
    return another;
  }

  String stringCreator(int len, Random rng, String letters) {
    final indices =
        new List<int>.generate(len, (i) => rng.nextInt(letters.length));
    return indices.map((i) => letters[i]).join();
  }

// [minLength .. maxLength], open interval
  int lengthPicker(Random rng, int minLength, int maxLength) {
    assert(minLength < maxLength);
    return rng.nextInt(maxLength + 1 - minLength) + minLength;
  }
}
