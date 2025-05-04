import 'package:fl_chart/fl_chart.dart';

class ProgressPoint {
  final double x;
  final double y;
  final String label;

  ProgressPoint({required this.x, required this.y, required this.label});

  factory ProgressPoint.fromJson(Map<String, dynamic> json, String periodType) {
    String label = json['x'];
    double x;

    if (periodType == 'monthly') {
      // Extract S1, S2, etc.
      x = double.tryParse(label.split('-').last.replaceAll('S', '')) ?? 0.0;
    } else {
      // Temporarily use 0.0 for yearly, we'll fix x in the frontend
      x = 0.0;
    }

    return ProgressPoint(
      x: x,
      y: (json['y'] as num).toDouble(),
      label: label,
    );
  }

  FlSpot toFlSpot() => FlSpot(x, y);

  // ✅ copyWith method
  ProgressPoint copyWith({double? x, double? y, String? label}) {
    return ProgressPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      label: label ?? this.label,
    );
  }
}
