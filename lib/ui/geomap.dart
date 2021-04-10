import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geo_quizz/models/continent.dart';
import 'package:geo_quizz/models/country.dart';
import 'package:geo_quizz/models/geopoint.dart';

class GeoMap extends StatefulWidget {
  const GeoMap({
    required this.continent,
    required this.onCountryTap,
  });

  final Continent continent;
  final Function(Country) onCountryTap;

  @override
  _GeoMapState createState() => _GeoMapState();
}

class _GeoMapState extends State<GeoMap> {
  Size? _size;
  GlobalKey _mapKey = GlobalKey();
  Country? _hoveredCountry;

  Color get backgroundColor => Colors.white;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    final RenderBox? renderBox = _mapKey.currentContext?.findRenderObject() as RenderBox;
    _size = renderBox!.size;
  }

  void _onHover(PointerHoverEvent event) {
    if (_size == null) return;
    GeoPoint point = GeoPoint(
      event.localPosition.dx / _size!.width,
      event.localPosition.dy / _size!.height,
    );
    final hovered = widget.continent.find(point);
    if (hovered != _hoveredCountry) {
      setState(() {
        _hoveredCountry = hovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.continent.meta.aspectRatio,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: backgroundColor,
        child: GestureDetector(
          onTap: () {
            if (_hoveredCountry != null) {
              widget.onCountryTap(_hoveredCountry!);
            }
          },
          child: MouseRegion(
            onHover: _onHover,
            child: CustomPaint(
              key: _mapKey,
              painter: CountryPainter(
                countries: widget.continent.countries,
                hovered: _hoveredCountry,
                borderColor: backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountryPainter extends CustomPainter {
  CountryPainter({required this.countries, required this.hovered, required this.borderColor});

  final List<Country> countries;
  final Country? hovered;
  final Color borderColor;

  Path _drawCountry(Path path, Country country, Size size) {
    for (final polygon in country.polygons) {
      path.moveTo(polygon.points[0].x * size.width, polygon.points[0].y * size.height);
      for (final point in polygon.points) {
        path.lineTo(point.x * size.width, point.y * size.height);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint stroke = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (final country in countries) {
      Paint fill = Paint()
        ..color = country.color
        ..style = PaintingStyle.fill;

      Path path = Path();
      path = _drawCountry(path, country, size);
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }

    if (hovered != null) {
      Paint hoverFill = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      Path hoveredPath = _drawCountry(Path(), hovered!, size);

      canvas.drawPath(hoveredPath, hoverFill);
      canvas.drawPath(hoveredPath, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
