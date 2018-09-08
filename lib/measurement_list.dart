import 'package:ca_cop/measurement_card.dart';
import 'package:ca_cop/stringComparison/string_comparison.dart';
import 'package:flutter/material.dart';

class MeasurementList extends StatelessWidget {
  final String title;
  final int seed;

  MeasurementList({
    Key key,
    @required this.title,
    @required this.seed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              MeasurementCard(
                seed: seed,
                title: 'String Comparison',
                subtitle:
                    'This test aims to measure the ability of quick judgement.',
                builder: (BuildContext context) => StringComparison(
                      title: 'String Comparison',
                      seed: seed,
                    ),
              ),
              MeasurementCard(
                seed: seed,
                title: 'Icon recollection',
                subtitle: 'under construction...',
                builder: (BuildContext context) => StringComparison(
                      title: 'String Comparison',
                      seed: seed,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
