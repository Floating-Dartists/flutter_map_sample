import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class NewPolylineLayerOptions extends LayerOptions {
  final List<Polyline> polylines;
  final bool polylineCulling;
  final bool updateCanvas;

  NewPolylineLayerOptions({
    Key? key,
    this.polylines = const [],
    this.polylineCulling = false,
    // ignore: prefer_void_to_null
    Stream<Null>? rebuild,
    this.updateCanvas = true,
  }) : super(key: key, rebuild: rebuild) {
    if (polylineCulling) {
      for (var polyline in polylines) {
        polyline.boundingBox = LatLngBounds.fromPoints(polyline.points);
      }
    }
  }
}
