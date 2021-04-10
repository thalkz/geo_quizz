import 'dart:math';

import 'package:geo_quizz/models/geopoint.dart';

class BoundingBox {
  late final GeoPoint _min;
  late final GeoPoint _max;

  double get width => _max.x - _min.x;

  double get height => _max.y - _min.y;

  double get minX => _min.x;

  double get minY => _min.y;

  BoundingBox({required GeoPoint topLeft, required GeoPoint bottomRight})
      : _min = topLeft,
        _max = bottomRight;

  BoundingBox.fromPoints(List<GeoPoint> points) {
    double minX = points[0].x, maxX = points[0].x;
    double minY = points[0].y, maxY = points[0].y;
    for (int n = 1; n < points.length; n++) {
      final point = points[n];
      minX = min(point.x, minX);
      maxX = max(point.x, maxX);
      minY = min(point.y, minY);
      maxY = max(point.y, maxY);
    }
    _min = GeoPoint(minX, minY);
    _max = GeoPoint(maxX, maxY);
  }

  bool contains(GeoPoint point) => point.x >= _min.x && point.x <= _max.x && point.y >= _min.y && point.y <= _max.y;

  @override
  String toString() => 'BoundingBox($_min, $_max)';
}
