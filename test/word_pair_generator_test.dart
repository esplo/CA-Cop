import 'dart:math';

import 'package:ca_cop/stringComparison/word_pair.dart';
import 'package:test/test.dart';

void main() {
  WordPairGenerator wpg;
  setUp(() {
    wpg = WordPairGenerator(minLength: 3, maxLength: 8, seed: 1);
  });

  test('letterSeed', () {
    expect(wpg.letterSeed(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  });

  test('generate', () {
    final rng = new Random(11);
    expect(
        wpg.generate(rng, 3),
        equals([
          WordPair('JLYCH', 'JGYCH'),
          WordPair('YUITJG', 'YUOTJG'),
          WordPair('FKY', 'FKY'),
        ]));
  });

  test('makeAnother', () {
    final rng = new Random(0);
    final str = "hoge";
    final letters = "abcde";

    expect(wpg.makeAnother(rng, str, letters), equals("hoge"));
    expect(wpg.makeAnother(rng, str, letters), equals("hoge"));
    expect(wpg.makeAnother(rng, str, letters), equals("hogb"));
  });

  test('stringCreator', () {
    final rng = new Random(0);
    final letters = "abcde";

    expect(wpg.stringCreator(5, rng, letters), equals("aeeeb"));
    expect(wpg.stringCreator(10, rng, letters), equals("bebbeedccb"));
    expect(
        wpg.stringCreator(100, rng, letters),
        equals(
            "ecadddaabbacbecaadbcdbecedbbeeddaddacccceedddeeabbbecaceadacdbbaccddcbcabceeebcbadcdbdbebdededbaddca"));
  });

  test('lengthPicker', () {
    final rng = new Random(0);
    for (var i = 0; i < 100; i++) {
      final len = wpg.lengthPicker(rng, 1, 10);
      expect(len, greaterThanOrEqualTo(1));
      expect(len, lessThanOrEqualTo(10));
    }
  });
}
