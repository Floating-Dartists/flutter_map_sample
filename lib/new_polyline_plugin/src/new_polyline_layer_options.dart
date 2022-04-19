import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class NewPolylineLayerOptions extends LayerOptions {
  /// List of polylines to draw.
  final List<Polyline> polylines;

  final bool polylineCulling;

  /// {@macro newPolylinePainter.saveLayers}
  ///
  /// By default, this is value is set to `false` to improve performances on
  /// layers containing a lot of [Polyline].
  final bool saveLayers;

  NewPolylineLayerOptions({
    Key? key,
    this.polylines = const [],
    this.polylineCulling = false,
    // ignore: prefer_void_to_null
    Stream<Null>? rebuild,
    this.saveLayers = false,
  }) : super(key: key, rebuild: rebuild) {
    if (polylineCulling) {
      for (var polyline in polylines) {
        polyline.boundingBox = LatLngBounds.fromPoints(polyline.points);
      }
    }
  }
}
