import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_quizz/models/bounding_box.dart';
import 'package:geo_quizz/models/geopoint.dart';
import 'package:geo_quizz/models/polygon.dart';

final errorColors = [
  Colors.teal.shade100,
  Colors.teal.shade200,
  Colors.teal.shade300,
  Colors.teal.shade400,
  Colors.teal.shade500,
  Colors.teal.shade600,
  Colors.teal.shade700,
];

class Country {
  final String name;
  final List<Polygon> polygons;
  bool active = false;
  int errorCount = 0;

  Color get color {
    if (active) {
      return Colors.blue;
    } else if (errorCount < errorColors.length) {
      return errorColors[errorCount];
    } else {
      return errorColors[errorColors.length - 1];
    }
  }

  Country(this.name, this.polygons);

  List<GeoPoint> get points => polygons.fold([], (total, polygon) => total..addAll(polygon.points));

  bool get isMultiRegion => polygons.length > 1;

  factory Country.fromGeoJson(data, BoundingBox bbox) {
    final isMultiRegion = data['geometry']['type'] == 'MultiPolygon';
    if (isMultiRegion) {
      return Country(
        data['properties']['name'],
        data['geometry']['coordinates']
            .map<Polygon>((list) => Polygon(list[0].map<GeoPoint>((data) => GeoPoint.fromGeoJson(data, bbox)).toList()))
            .toList(),
      );
    } else {
      return Country(
        data['properties']['name'],
        data['geometry']['coordinates']
            .map<Polygon>((list) => Polygon(list.map<GeoPoint>((data) => GeoPoint.fromGeoJson(data, bbox)).toList()))
            .toList(),
      );
    }
  }

  void reset() {
    active = false;
    errorCount = 0;
  }

  void setActive() {
    active = true;
  }

  void incrementError() {
    errorCount++;
  }
}
