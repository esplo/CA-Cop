import 'package:ca_cop/scoreHistory/score_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ScoreChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ScoreChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory ScoreChart.withData(List<ScoreData> data) {
    return new ScoreChart(
      _createSampleData(data),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ScoreData, DateTime>> _createSampleData(
      List<ScoreData> data) {
    return [
      new charts.Series<ScoreData, DateTime>(
        id: 'Score',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ScoreData sales, _) => sales.timestamp,
        measureFn: (ScoreData sales, _) => sales.score,
        data: data,
      )
    ];
  }
}
