import 'package:ca_cop/string_comparison.dart';
import 'package:flutter/material.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes =
      true; // ignore: deprecated_member_use
  return runApp(MyApp());
}

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
