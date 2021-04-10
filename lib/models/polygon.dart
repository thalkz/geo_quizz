import 'package:geo_quizz/models/bounding_box.dart';
import 'package:geo_quizz/models/geopoint.dart';

class Polygon {
  final List<GeoPoint> points;
  final BoundingBox boundingBox;

  Polygon(this.points) : boundingBox = BoundingBox.fromPoints(points);

  pointIsInside(GeoPoint point) {
    var isInside = false;

    if (!boundingBox.contains(point)) {
      return false;
    }

    var i = 0, j = points.length - 1;
    for (j = 0; i < points.length; j = i++) {
      if ((points[i].y > point.y) != (points[j].y > point.y) &&
          point.x < (points[j].x - points[i].x) * (point.y - points[i].y) / (points[j].y - points[i].y) + points[i].x) {
        isInside = !isInside;
      }
    }

    return isInside;
  }
}
