import 'package:flutter/cupertino.dart';
import 'package:geo_quizz/ui/home_page.dart';

void main() {
  runApp(
    CupertinoApp(
      title: 'GeoQuizz',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    ),
  );
}
