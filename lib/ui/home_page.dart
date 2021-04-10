import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geo_quizz/models/bounding_box.dart';
import 'package:geo_quizz/models/continent.dart';
import 'package:geo_quizz/models/continent_meta.dart';
import 'package:geo_quizz/models/geopoint.dart';
import 'package:geo_quizz/ui/game_page.dart';

const continentsNames = [
  ContinentMeta(
    name: 'Africa',
    path: 'res/africa.json',
    topLeft: GeoPoint(0.4, 0.20),
    bottomRight: GeoPoint(0.7, 0.75),
  ),
  ContinentMeta(
    name: 'Asia',
    path: 'res/asia.json',
    topLeft: GeoPoint(0.55, 0.15),
    bottomRight: GeoPoint(0.92, 0.6),
  ),
  ContinentMeta(
    name: 'Europe',
    path: 'res/europe.json',
    topLeft: GeoPoint(0.45, 0.07),
    bottomRight: GeoPoint(0.65, 0.32),
  ),
  ContinentMeta(
    name: 'North America',
    path: 'res/north_america.json',
    topLeft: GeoPoint(0.01, 0.01),
    bottomRight: GeoPoint(0.45, 0.5),
  ),
  ContinentMeta(
    name: 'South America',
    path: 'res/south_america.json',
    topLeft: GeoPoint(0.20, 0.4),
    bottomRight: GeoPoint(0.45, 0.85),
  ),
  ContinentMeta(
    name: 'Oceania',
    path: 'res/oceania.json',
    topLeft: GeoPoint(0.77, 0.38),
    bottomRight: GeoPoint(1, 0.90),
  ),
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Continent> _continents = [];

  @override
  void initState() {
    super.initState();
    _loadContinents();
  }

  void _loadContinents() async {
    for (final meta in continentsNames) {
      _continents.add(await _loadJson(meta));
    }
    setState(() {});
  }

  Future<Continent> _loadJson(ContinentMeta meta) async {
    final data = await DefaultAssetBundle.of(context).loadString(meta.path);
    return Continent.fromMap(meta, json.decode(data));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'GeoQuizz',
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(fontSize: 64),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: continentsNames
                    .map(
                      (meta) => CupertinoButton.filled(
                        child: Text(meta.name),
                        onPressed: () {
                          final selected = _continents.firstWhere((continent) => continent.name == meta.name);
                          Navigator.of(context).push(CupertinoPageRoute(builder: (_) => GamePage(continent: selected)));
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
