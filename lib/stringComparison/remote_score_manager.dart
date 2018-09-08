import 'dart:async';

import 'package:ca_cop/stringComparison/answer_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef void FetchHistoryCallback(QuerySnapshot data);

class RemoteScoreManager {
  final String _userCollectionName = 'users';
  final String _resultCollectionName = 'sc-results';
  final String _resultDetailCollectionName = 'sc-results-detail';
  final String _scoreVersion = '0.0.2';

  String uid;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  RemoteScoreManager._internal(this.uid);

  static Future<RemoteScoreManager> instance() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    return RemoteScoreManager._internal(currentUser.uid);
  }

  void fetchHistory(FetchHistoryCallback callback) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(uid)
        .collection(_resultCollectionName)
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((QuerySnapshot data) => callback(data));
  }

  void fetchTodaysHistory(FetchHistoryCallback callback) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(uid)
        .collection(_resultCollectionName)
        .where('timestamp',
            isGreaterThan: DateTime.now().subtract(new Duration(days: 1)))
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((QuerySnapshot data) => callback(data));
  }

  void add(int score, List<AnswerHistory> answers) async {
    DocumentReference ref = await Firestore.instance
        .collection(_userCollectionName)
        .document(uid)
        .collection(_resultCollectionName)
        .add({
      'version': _scoreVersion,
      'timestamp': DateTime.now(),
      'score': score,
    });

    final CollectionReference r = Firestore.instance
        .collection(_userCollectionName)
        .document(uid)
        .collection(_resultDetailCollectionName);

    for (AnswerHistory ans in answers) {
      r.add({
        'session': ref,
        'duration': ans.time.toString(),
        'isSame': ans.isSame,
        'gained': ans.score,
      });
    }
  }
}
