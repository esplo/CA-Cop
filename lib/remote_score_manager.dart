import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef void FetchHistoryCallback(QuerySnapshot data);

class RemoteScoreManager {
  final String _userCollectionName = 'users';
  final String _resultCollectionName = 'sc-results';
  final String _scoreVersion = '0.0.1';

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
        .then((data) => callback(data));
  }

  void add(int score) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(uid)
        .collection(_resultCollectionName)
        .add({
      'version': _scoreVersion,
      'timestamp': DateTime.now(),
      'score': score,
    });
  }
}
