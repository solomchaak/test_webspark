import 'package:test_webspark/model/response_data.dart';

class Result {
  final List<Point> points;
  final List<List<String>> field;

  const Result({
    required this.points,
    required this.field,
  });

  Map<String, dynamic> toJson() => {
        'points': points.map((p) => p.toJson()).toList(),
        'field': field,
      };

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      points: (json['points'] as List)
          .map((p) => Point.fromJson(p))
          .toList(),
      field: (json['field'] as List)
          .map((row) => (row as List).cast<String>())
          .toList(),
    );
  }
}
