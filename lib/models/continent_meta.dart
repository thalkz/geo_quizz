import 'package:geo_quizz/models/geopoint.dart';

class ContinentMeta {
  final String name;
  final String path;
  final GeoPoint topLeft;
  final GeoPoint bottomRight;

  const ContinentMeta({
    required this.name,
    required this.path,
    required this.topLeft,
    required this.bottomRight,
  });
}
