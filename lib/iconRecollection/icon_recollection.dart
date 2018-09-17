import 'dart:async';
import 'dart:math';

import 'package:ca_cop/iconRecollection/answer_history.dart';
import 'package:ca_cop/iconRecollection/icon_grid.dart';
import 'package:ca_cop/ui/timer_display.dart';
import 'package:flutter/material.dart';

class IconRecollection extends StatefulWidget {
  final String title;

  final Random rng;

  IconRecollection({
    Key key,
    @required this.title,
    @required seed,
  })  : rng = new Random(seed ?? DateTime.now().millisecondsSinceEpoch),
        super(key: key);

  @override
  _IconRecollectionState createState() => _IconRecollectionState();

  final int GRID_ROW = 5;
  final int GRID_COLUMN = 5;
  final int ICON_COUNT = 15;
  final List<IconData> iconData = const [
    Icons.add,
    Icons.access_time,
    Icons.accessibility,
    Icons.adjust,
    Icons.airplanemode_active,
    Icons.all_inclusive,
    Icons.android,
    Icons.arrow_downward,
    Icons.attachment,
    Icons.build,
    Icons.call,
    Icons.check,
    Icons.clear,
    Icons.create,
    Icons.delete,
    Icons.drive_eta,
    Icons.favorite,
    Icons.headset,
    Icons.language,
    Icons.local_dining,
  ];
}

class _IconRecollectionState extends State<IconRecollection> {
  final int _memoryTimeLimit = 5;
  final int _questionCount = 5;

  bool _running;
  bool _memorying;
  int _questionNumber;

  int _score;
  int _remainingTime;
  Timer _timer;
  DateTime _beginningTime;
  List<AnswerHistory> _answerHistory;

  List<IconData> _pickedIcons = [];
  List<IconData> _iconGridData = [];

  int _answerRow = 0;
  int _answerColumn = 0;
  List<IconData> _questions = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _score = 0;
    _running = false;
    _memorying = false;
    _answerHistory = [];

    _pickedIcons = pickIcons(widget.ICON_COUNT);
    _iconGridData =
        makeIconsWithPadding(widget.GRID_ROW, widget.GRID_COLUMN, _pickedIcons);
  }

  void _startSession() {
    setState(() {
      _init();
      _running = true;
      _memorying = true;
      _remainingTime = _memoryTimeLimit;
      _questionNumber = 0;
      _timer =
          Timer.periodic(Duration(seconds: 1), (timer) => this._countdown());
      _beginningTime = DateTime.now();

      _questions = _makeQuestions();
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
      _memorying = false;
    });
  }

  List<IconData> makeIconsWithPadding(int n, int m, List<IconData> icons) {
    assert(n * m >= icons.length);
    assert(n + m <= icons.length);
    assert(n > 1); // to avoid an infinite loop in the balanced-placement
    assert(m > 1);

    final List<IconData> res = List.filled(n * m, null);

    // well balanced
    // horizontal
    for (var i = 0; i < m; i++) {
      final int u = widget.rng.nextInt(n);
      res[u * m + i] = icons[i];
    }

    // vertical
    for (var i = 0; i < n; i++) {
      final int u = widget.rng.nextInt(m);
      final int t = u + n * i;
      if (res[t] != null) {
        i--;
        continue;
      }
      res[t] = icons[m + i];
    }

    // random
    List<int> remList = [];
    for (var i = 0; i < n * m; i++) {
      if (res[i] == null) {
        remList.add(i);
      }
    }
    remList.shuffle(widget.rng);
    for (var i = n + m; i < icons.length; i++) {
      res[remList[i - n - m]] = icons[i];
    }

    return res;
  }

  List<IconData> pickIcons(int n) {
    final icons = List<IconData>.from(widget.iconData)..shuffle(widget.rng);
    return icons.take(n).toList();
  }

  List<IconData> _makeQuestions() {
    final icons = List<IconData>.from(_pickedIcons)..shuffle(widget.rng);
    return icons.toList();
  }

  void _answer() {
    final ans = _answerRow * widget.GRID_COLUMN + _answerColumn;

    // search answer
    int gainedScore = 0;
    int actualPos = -1;
    for (var i = 0; i < _iconGridData.length; i++) {
      if (_iconGridData[i] == _questions[_questionNumber]) {
        actualPos = i;
        break;
      }
    }
    if (ans == actualPos) {
      gainedScore += 10;
    }

    _answerHistory.add(AnswerHistory(gainedScore, ans, actualPos));

    setState(() {
      _score += gainedScore;
      _questionNumber += 1;
      if (_questionNumber >= _questionCount) {
        // finish session
        _running = false;
      }
    });

    _answerRow = 0;
    _answerColumn = 0;
  }

  void _handleRowAnswerValueChanged(int value) {
    setState(() {
      _answerRow = value;
    });
  }

  void _handleColumnAnswerValueChanged(int value) {
    setState(() {
      _answerColumn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget memoryContents = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimerDisplay(
          remainingTime: _remainingTime,
        ),
        IconGrid(column: widget.GRID_COLUMN, iconData: _iconGridData),
      ],
    );

    List<Widget> beforeStartContents = [
      RaisedButton(
        onPressed: () => _startSession(),
        child: Text('START'),
      )
    ];
    if (_answerHistory.isNotEmpty) {
      beforeStartContents.add(
        Text(_score.toString()),
      );
      beforeStartContents.addAll(
        _answerHistory.map((v) => Text(v.pretty())).toList(),
      );
    }

    Widget content;
    if (!_running) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: beforeStartContents,
      );
    } else if (_memorying) {
      content = memoryContents;
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text((_questionNumber + 1).toString()),
          Icon(_questions[_questionNumber]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<int>(
                  value: 0,
                  groupValue: _answerRow,
                  onChanged: _handleRowAnswerValueChanged),
              Text('A'),
              Radio<int>(
                  value: 1,
                  groupValue: _answerRow,
                  onChanged: _handleRowAnswerValueChanged),
              Text('B'),
              Radio<int>(
                  value: 2,
                  groupValue: _answerRow,
                  onChanged: _handleRowAnswerValueChanged),
              Text('C'),
              Radio<int>(
                  value: 3,
                  groupValue: _answerRow,
                  onChanged: _handleRowAnswerValueChanged),
              Text('D'),
              Radio<int>(
                  value: 4,
                  groupValue: _answerRow,
                  onChanged: _handleRowAnswerValueChanged),
              Text('E'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<int>(
                  value: 0,
                  groupValue: _answerColumn,
                  onChanged: _handleColumnAnswerValueChanged),
              Text('0'),
              Radio<int>(
                  value: 1,
                  groupValue: _answerColumn,
                  onChanged: _handleColumnAnswerValueChanged),
              Text('1'),
              Radio<int>(
                  value: 2,
                  groupValue: _answerColumn,
                  onChanged: _handleColumnAnswerValueChanged),
              Text('2'),
              Radio<int>(
                  value: 3,
                  groupValue: _answerColumn,
                  onChanged: _handleColumnAnswerValueChanged),
              Text('3'),
              Radio<int>(
                  value: 4,
                  groupValue: _answerColumn,
                  onChanged: _handleColumnAnswerValueChanged),
              Text('4'),
            ],
          ),
          RaisedButton(
            onPressed: () => _answer(),
            child: Text('ANSWER'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: content,
      ),
    );
  }
}
