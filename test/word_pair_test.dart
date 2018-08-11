import 'package:ca_cop/word_pair.dart';
import 'package:test/test.dart';

void main() {
  test('equals', () {
    WordPair wp = WordPair("hoge", "fuga");
    WordPair wp2 = WordPair("hoge", "fuga");
    WordPair wp3 = WordPair("hoge", "fuge");
    expect(wp, equals(wp2));
    expect(wp, isNot(wp3));
  });
}
