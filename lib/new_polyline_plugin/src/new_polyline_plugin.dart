import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'new_polyline_layer.dart';
import 'new_polyline_layer_options.dart';

class NewPolylinePlugin extends MapPlugin {
  @override
  Widget createLayer(
    LayerOptions options,
    MapState mapState,
    // ignore: prefer_void_to_null
    Stream<Null> stream,
  ) {
    return NewPolylineLayer(
      options as NewPolylineLayerOptions,
      mapState,
      stream,
    );
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is NewPolylineLayerOptions;
  }
}
