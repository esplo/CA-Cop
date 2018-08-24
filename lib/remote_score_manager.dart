import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

typedef void FetchHistoryCallback(QuerySnapshot data);

class RemoteScoreManager {
  final String _userCollectionName = 'users';
  final String _resultCollectionName = 'sc-results';
  final String _scoreVersion = '0.0.1';

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String deviceID;

  RemoteScoreManager._internal(this.deviceID);

  static Future<RemoteScoreManager> instance() async {
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

    return RemoteScoreManager._internal(id);
  }

  static String _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.id;
  }

  static String _readIosDeviceInfo(IosDeviceInfo data) {
    return data.identifierForVendor;
  }

  void fetchHistory(FetchHistoryCallback callback) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(deviceID)
        .collection(_resultCollectionName)
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((data) => callback(data));
  }

  void add(int score) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(deviceID)
        .collection(_resultCollectionName)
        .add({
      'scoreVersion': _scoreVersion,
      'timestamp': DateTime.now(),
      'score': score,
    });
  }
}
