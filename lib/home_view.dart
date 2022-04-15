import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_sample/map_view.dart';
import 'package:latlong2/latlong.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapView(
                    title: 'Trafic',
                    polylineLayerBuilder: () async {
                      final data = await rootBundle
                          .loadString('assets/trafic_data.json');
                      final lines = kIsWeb
                          ? _parseTraficLines(data)
                          : await compute(_parseTraficLines, data);
                      return PolylineLayerOptions(
                        polylines: lines,
                        polylineCulling: false,
                      );
                    },
                  ),
                ),
              ),
              child: const Text('Trafic'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapView(
                    title: 'Snow',
                    initialZoom: 14.0,
                    polylineLayerBuilder: () async {
                      final data =
                          await rootBundle.loadString('assets/snow_data.json');
                      final lines = kIsWeb
                          ? _parseSnowLines(data)
                          : await compute(_parseSnowLines, data);
                      return PolylineLayerOptions(
                        polylines: lines,
                        polylineCulling: false,
                      );
                    },
                  ),
                ),
              ),
              child: const Text('Snow'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The following methods should run inside an isolate to avoid blocking the UI.

List<Polyline> _parseTraficLines(String data) {
  final json = jsonDecode(data) as Map<String, dynamic>;
  final records = (json['records'] as Iterable).cast<Map<String, dynamic>>();
  final lines = <Polyline>[];
  for (final e in records) {
    final fields = e['fields'] as Map<String, dynamic>;
    final coords = (fields['geo_shape']['coordinates'] as Iterable)
        .cast<Iterable>()
        .map((e) => List<double>.from(e))
        .toList();
    final points = <LatLng>[];
    for (final e in coords) {
      points.add(LatLng(e[1], e[0]));
    }
    lines.add(Polyline(points: points, color: Colors.red));
  }
  return lines;
}

List<Polyline> _parseSnowLines(String data) {
  final json = jsonDecode(data) as Map<String, dynamic>;
  final records = (json['records'] as Iterable).cast<Map<String, dynamic>>();
  final lines = <Polyline>[];
  for (final e in records) {
    final fields = e['fields'] as Map<String, dynamic>;
    final coordsData =
        (fields['geo_shape']['coordinates'] as Iterable).cast<Iterable>();
    for (final line in coordsData) {
      final _line = List<Iterable>.from(line);
      final points = <LatLng>[];
      for (final point in _line) {
        final _point = point.cast<double>().toList();
        points.add(LatLng(_point[1], _point[0]));
      }
      lines.add(
        Polyline(points: points, color: Colors.blue),
      );
    }
  }
  return lines;
}
