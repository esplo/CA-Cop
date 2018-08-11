import 'dart:async';

import 'package:ca_cop/question_area.dart';
import 'package:ca_cop/score.dart';
import 'package:ca_cop/word_pair.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final int _seed;

  MyApp({int seed}) : _seed = seed ?? DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CA Cop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StringComparison(
        title: 'String Comparison Task',
        seed: _seed,
      ),
    );
  }
}

class StringComparison extends StatefulWidget {
  StringComparison({Key key, this.title, int seed})
      : generator = WordPairGenerator(seed: seed),
        super(key: key);

  final String title;
  final WordPairGenerator generator;

  @override
  _StringComparisonState createState() => _StringComparisonState();
}

class _StringComparisonState extends State<StringComparison> {
  final int _defaultTimeLimit = 30;

  bool _running;
  int _score;
  int _remainingTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _score = 0;
    _running = false;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _score = 0;
      _remainingTime = _defaultTimeLimit;
      _running = true;
      _timer =
          Timer.periodic(Duration(seconds: 1), (timer) => this._countdown());
    });
  }

  void _countdown() {
    setState(() {
      _remainingTime--;
      if (_remainingTime <= 0) {
        _remainingTime = 0;
        _timer.cancel();
        _running = false;
      }
    });
  }

  void _nextQuestion(bool isSame) {
    setState(() {
      if (isSame == widget.generator.current().isEqual()) {
        _score++;
      } else {
        _score -= 2;
      }

      widget.generator.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Score(score: _score),
            _running
                ? QuestionArea(
                    currentWordPair: widget.generator.current(),
                    nextQuestion: _nextQuestion,
                    remainingTime: _remainingTime,
                  )
                : Container(),
            !_running
                ? RaisedButton(
                    onPressed: () => _startSession(),
                    child: Text('START'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
