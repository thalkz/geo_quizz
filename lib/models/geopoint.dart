import 'package:geo_quizz/models/bounding_box.dart';

class GeoPoint {
  final double x;
  final double y;

  static double _toX(double lat, BoundingBox bbox) => ((lat + 180) / 360 - bbox.minX) / bbox.width;
  static double _toY(double lng, BoundingBox bbox) => ((90 - lng) / 180 - bbox.minY) / bbox.height;

  const GeoPoint(this.x, this.y);

  GeoPoint.fromLatLng(double lat, double lng, BoundingBox bbox)
      : x = _toX(lat, bbox),
        y = _toY(lng, bbox);

  GeoPoint.fromGeoJson(List data, BoundingBox bbox)
      : x = _toX(data[0] * 1.0, bbox),
        y = _toY(data[1] * 1.0, bbox);

  @override
  String toString() => 'Point(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
}
