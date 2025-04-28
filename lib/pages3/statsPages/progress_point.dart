import 'package:fl_chart/fl_chart.dart';

class ProgressPoint {
  final double x;
  final double y;

  ProgressPoint({required this.x, required this.y});

  factory ProgressPoint.fromJson(Map<String, dynamic> json) {
    return ProgressPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  FlSpot toFlSpot() => FlSpot(x, y);
}

