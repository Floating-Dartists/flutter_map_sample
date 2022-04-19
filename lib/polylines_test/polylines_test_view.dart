import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_sample/polylines_test/map_view.dart';
import 'package:flutter_map_sample/new_polyline_plugin/new_polyline_plugin.dart';
import 'package:latlong2/latlong.dart';

class PolylinesTestView extends StatefulWidget {
  static const routeName = '/polylines_test';

  const PolylinesTestView({Key? key}) : super(key: key);

  @override
  State<PolylinesTestView> createState() => _PolylinesTestViewState();
}

class _PolylinesTestViewState extends State<PolylinesTestView> {
  final _updateCanvas = ValueNotifier<bool>(true);
  final _optimizePolylines = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _updateCanvas.dispose();
    _optimizePolylines.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polylines')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                MapView.routeName,
                arguments: MapViewArgs(
                  title: 'Trafic',
                  polylineLayerBuilder: () async {
                    final data =
                        await rootBundle.loadString('assets/trafic_data.json');
                    final lines = _parseTraficLines(data);
                    return NewPolylineLayerOptions(
                      polylines: lines,
                      polylineCulling: true,
                      saveLayers: _updateCanvas.value,
                    );
                  },
                ),
              ),
              child: const Text('Trafic'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                MapView.routeName,
                arguments: MapViewArgs(
                  title: 'Snow',
                  polylineLayerBuilder: () async {
                    final data =
                        await rootBundle.loadString('assets/snow_data.json');
                    final lines = _parseSnowLines(data);
                    return NewPolylineLayerOptions(
                      polylines: lines,
                      polylineCulling: true,
                      saveLayers: _updateCanvas.value,
                    );
                  },
                ),
              ),
              child: const Text('Snow'),
            ),
            const SizedBox(height: 8),
            OptionSwitch(controller: _updateCanvas, label: 'Update canvas'),
            const SizedBox(height: 8),
            OptionSwitch(
              controller: _optimizePolylines,
              label: 'Optimize polylines',
            ),
          ],
        ),
      ),
    );
  }
}

class OptionSwitch extends StatelessWidget {
  final ValueNotifier<bool> controller;
  final String label;

  const OptionSwitch({Key? key, required this.controller, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        ValueListenableBuilder<bool>(
          valueListenable: controller,
          builder: (_, value, __) {
            return Switch(
              value: value,
              onChanged: (_) => controller.value = !value,
            );
          },
        ),
      ],
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
