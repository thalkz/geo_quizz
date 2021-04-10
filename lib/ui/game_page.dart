import 'package:flutter/cupertino.dart';
import 'package:geo_quizz/models/continent.dart';
import 'package:geo_quizz/models/country.dart';
import 'package:geo_quizz/ui/geomap.dart';

class GamePage extends StatefulWidget {
  const GamePage({required this.continent});

  final Continent continent;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<String> _toGuessList;
  int _guessIndex = 0;
  bool _displayScore = false;

  String get nextToGuess => _toGuessList[_guessIndex];

  double get successPercent => (1.0 - widget.continent.totalError / _toGuessList.length) * 100.0;

  @override
  void initState() {
    super.initState();
    _toGuessList = widget.continent.countries.map((country) => country.name).toList();
    _toGuessList.shuffle();
  }

  void _onCountryTap(Country country) {
    if (_toGuessList[_guessIndex] == country.name) {
      if (_guessIndex >= _toGuessList.length - 1) {
        setState(() {
          country.setActive();
          _displayScore = true;
        });
      } else {
        setState(() {
          country.setActive();
          _guessIndex++;
        });
      }
    } else {
      setState(() {
        country.incrementError();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.continent.reset();
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: _displayScore ? Text('Your score : ${successPercent.toStringAsFixed(1)}%') : Text(nextToGuess),
        ),
        child: GeoMap(
          continent: widget.continent,
          onCountryTap: _onCountryTap,
        ),
      ),
    );
  }
}
