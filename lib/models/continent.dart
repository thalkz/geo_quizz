import 'package:geo_quizz/models/continent_meta.dart';
import 'package:geo_quizz/models/country.dart';
import 'package:geo_quizz/models/geopoint.dart';

class Continent {
  late final List<Country> countries;
  final ContinentMeta meta;


  Continent.fromMap(this.meta, Map data, bbox) {
    countries = data['features'].map<Country>((value) => Country.fromGeoJson(value, bbox)).toList();
  }

  Country? find(GeoPoint point) {
    for (final country in countries) {
      for (final polygon in country.polygons) {
        if (polygon.pointIsInside(point)) {
          return country;
        }
      }
    }
  }

  void reset() {
    for (final country in countries) {
      country.reset();
    }
  }

  int get totalError => countries.fold(0, (total, country) => country.errorCount > 0 ? total + 1 : total);
}
