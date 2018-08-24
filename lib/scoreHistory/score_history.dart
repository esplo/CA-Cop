import 'package:ca_cop/remote_score_manager.dart';
import 'package:ca_cop/scoreHistory/score_data.dart';
import 'package:flutter/material.dart';

class ScoreHistory extends StatefulWidget {
  ScoreHistory({Key key, @required this.remoteScoreManager})
      : title = 'Score History',
        super(key: key);

  final String title;
  final RemoteScoreManager remoteScoreManager;

  @override
  _ScoreHistoryState createState() => _ScoreHistoryState();
}

class _ScoreHistoryState extends State<ScoreHistory> {
  List<ScoreData> _scoreHistory = [];

  @override
  void initState() {
    super.initState();
    widget.remoteScoreManager.fetchHistory(setDataFromRemote);
  }

  void setDataFromRemote(data) {
    setState(() {
      _scoreHistory = data.documents
          .map<ScoreData>(
              (sp) => ScoreData(sp.data['score'].toInt(), sp.data['timestamp']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.sync),
              onPressed: () =>
                  widget.remoteScoreManager.fetchHistory(setDataFromRemote))
        ],
      ),
      body: ListView(
        children: _scoreHistory
            .map((e) => ListTile(
                  title: Text(e.toString()),
                ))
            .toList(),
      ),
    );
  }
}
