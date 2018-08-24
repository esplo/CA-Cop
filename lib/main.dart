import 'dart:async';

import 'package:ca_cop/main/question_area.dart';
import 'package:ca_cop/main/score.dart';
import 'package:ca_cop/main/word_pair.dart';
import 'package:ca_cop/remote_score_manager.dart';
import 'package:ca_cop/scoreHistory/score_history.dart';
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
  StringComparison({Key key, @required this.title, @required int seed})
      : generator = WordPairGenerator(seed: seed),
        super(key: key);

  final String title;
  final WordPairGenerator generator;

  @override
  _StringComparisonState createState() => _StringComparisonState();
}

class _StringComparisonState extends State<StringComparison> {
  final int _defaultTimeLimit = 30;

  RemoteScoreManager _remoteScoreManager;

  bool _running;
  int _score;
  int _remainingTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _score = 0;
    _running = false;
    _init();
  }

  void _init() async {
    _remoteScoreManager = await RemoteScoreManager.instance();
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
        this._finishSession();
      }
    });
  }

  void _finishSession() {
    setState(() {
      _remainingTime = 0;
      _timer.cancel();
      _running = false;
    });

    _remoteScoreManager.add(_score);
  }

  void _nextQuestion(bool isSame) {
    final pair = widget.generator.current();
    setState(() {
      if (isSame == pair.isEqual()) {
        // correct
        _score += isSame ? pair.word1.length : 4;
      } else {
        // wrong
        _score -= 10;
      }

      widget.generator.next();
    });
  }

  void _openHistory() {
    Navigator.push(context, new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return ScoreHistory(
          remoteScoreManager: _remoteScoreManager,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Score(score: _score),
              ),
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
      ),
    );
  }
}
