import 'package:ca_cop/remote_score_manager.dart';
import 'package:ca_cop/scoreHistory/score_chart.dart';
import 'package:ca_cop/scoreHistory/score_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<ScoreData> _scoreTodaysHistory = [];

  @override
  void initState() {
    super.initState();
    widget.remoteScoreManager.fetchHistory(setDataFromRemote);
    widget.remoteScoreManager.fetchTodaysHistory(setTodaysDataFromRemote);
  }

  List<ScoreData> _convertSnapshotIntoScoreData(QuerySnapshot sp) {
    return sp.documents
        .map<ScoreData>((sp) => ScoreData(
              sp.data['version'],
              sp.data['score'].toInt(),
              sp.data['timestamp'],
            ))
        .toList();
  }

  void setDataFromRemote(QuerySnapshot data) {
    setState(() {
      _scoreHistory = _convertSnapshotIntoScoreData(data);
    });
  }

  void setTodaysDataFromRemote(QuerySnapshot data) {
    setState(() {
      _scoreTodaysHistory = _convertSnapshotIntoScoreData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Today',
              ),
              Tab(
                icon: Icon(Icons.all_out),
                text: 'All',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _scoreTodaysHistory.isEmpty
                ? Center(
                    child: Text('loading... or no data'),
                  )
                : ScoreChart.withData(_scoreTodaysHistory),
            _scoreHistory.isEmpty
                ? Center(
                    child: Text('loading... or no data'),
                  )
                : ScoreChart.withData(_scoreHistory),
          ],
        ),
      ),
    );
  }
}
