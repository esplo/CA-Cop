import 'package:ca_cop/measurement_list.dart';
import 'package:flutter/material.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes =
      true; // ignore: deprecated_member_use
  return runApp(MyApp(
    seed: null,
  ));
}

class MyApp extends StatelessWidget {
  final int seed;

  MyApp({@required this.seed});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CA Cop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeasurementList(
        title: 'Measurement Methods',
        seed: seed,
      ),
    );
  }
}
