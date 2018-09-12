import 'dart:async';

import 'package:ca_cop/scoreHistory/score_history.dart';
import 'package:ca_cop/stringComparison/answer_history.dart';
import 'package:ca_cop/stringComparison/question_area.dart';
import 'package:ca_cop/stringComparison/remote_score_manager.dart';
import 'package:ca_cop/stringComparison/score.dart';
import 'package:ca_cop/stringComparison/word_pair.dart';
import 'package:flutter/material.dart';

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
  DateTime _beginningTime;
  List<AnswerHistory> _answerHistory;

  @override
  void initState() {
    super.initState();
    _score = 0;
    _running = false;
    _answerHistory = [];
    _init();
  }

  void _init() async {
    _remoteScoreManager = await RemoteScoreManager.instance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _score = 0;
      _remainingTime = _defaultTimeLimit;
      _running = true;
      _timer =
          Timer.periodic(Duration(seconds: 1), (timer) => this._countdown());
      _beginningTime = DateTime.now();
      _answerHistory = [];
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

    _remoteScoreManager.add(_score, _answerHistory);
  }

  void _nextQuestion(bool isSame) {
    final pair = widget.generator.current();

    var gainedScore = 0;
    if (isSame == pair.isEqual()) {
      // correct
      gainedScore = isSame ? pair.word1.length : 5;
    } else {
      // wrong
      gainedScore = -10;
    }

    // record history
    _answerHistory.add(AnswerHistory(
      DateTime.now().difference(_beginningTime),
      isSame,
      gainedScore,
      pair.word1,
      pair.word2,
    ));

    setState(() {
      _score += gainedScore;
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
    var contents = <Widget>[
      _running
          ? QuestionArea(
              currentWordPair: widget.generator.current(),
              nextQuestion: _nextQuestion,
              remainingTime: _remainingTime,
            )
          : RaisedButton(
              onPressed: () => _startSession(),
              child: Text('START'),
            ),
    ];

    if (!_running && _answerHistory.isNotEmpty) {
      contents.addAll([
        Score(score: _score),
        Expanded(
          child: ListView(
            children: _answerHistory.map((ah) => Text(ah.pretty())).toList(),
          ),
        ),
      ]);
    }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: contents,
        ),
      ),
    );
  }
}
