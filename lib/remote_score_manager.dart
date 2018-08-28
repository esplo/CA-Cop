import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef void FetchHistoryCallback(QuerySnapshot data);

class RemoteScoreManager {
  final String _userCollectionName = 'users';
  final String _resultCollectionName = 'sc-results';
  final String _scoreVersion = '0.0.1';

  String uid;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  RemoteScoreManager._internal(this.uid);

  static Future<RemoteScoreManager> instance() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    return RemoteScoreManager._internal(currentUser.uid);
  }

  // TODO: create button
  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
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
