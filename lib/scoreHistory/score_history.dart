import 'package:ca_cop/scoreHistory/score_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScoreHistory extends StatefulWidget {
  ScoreHistory({Key key, @required this.deviceID})
      : title = 'Score History',
        super(key: key);

  final String title;
  final String deviceID;

  @override
  _ScoreHistoryState createState() => _ScoreHistoryState();
}

class _ScoreHistoryState extends State<ScoreHistory> {
  List<ScoreData> _scoreHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    Firestore.instance
        .collection('result')
        .where("deviceID", isEqualTo: widget.deviceID)
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((data) => setState(() {
              _scoreHistory = data.documents
                  .map<ScoreData>((sp) =>
                      ScoreData(sp.data['score'].toInt(), sp.data['timestamp']))
                  .toList();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.sync), onPressed: _fetchHistory)
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
