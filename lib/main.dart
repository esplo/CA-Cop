import 'dart:async';
import 'dart:io';

import 'package:ca_cop/question_area.dart';
import 'package:ca_cop/score.dart';
import 'package:ca_cop/score_history.dart';
import 'package:ca_cop/word_pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String _deviceID;

  bool _running;
  int _score;
  int _remainingTime;
  Timer _timer;

  List<ScoreData> _scoreHistory = [];

  @override
  void initState() {
    super.initState();
    _score = 0;
    _running = false;

    _initPlatformState();
  }

  void _fetchHistory(String deviceID) {
    Firestore.instance
        .collection('result')
        .where("deviceID", isEqualTo: deviceID)
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((data) => setState(() {
              _scoreHistory = data.documents
                  .map<ScoreData>((sp) =>
                      ScoreData(sp.data['score'].toInt(), sp.data['timestamp']))
                  .toList();
            }));
  }

  Future<Null> _initPlatformState() async {
    String id;

    try {
      if (Platform.isAndroid) {
        id = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        id = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      id = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _deviceID = id;
    });

    _fetchHistory(id); // TODO:
  }

  String _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.id;
  }

  String _readIosDeviceInfo(IosDeviceInfo data) {
    return data.identifierForVendor;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startSession() {
    _fetchHistory(_deviceID); // TODO:
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

    Firestore.instance.collection('result').add({
      'deviceID': _deviceID,
      'timestamp': DateTime.now(),
      'score': _score,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              !_running ? History(scoreHistory: _scoreHistory) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
