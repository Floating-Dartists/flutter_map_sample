import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'new_polyline_plugin/new_polyline_plugin.dart';

typedef PolylineLayerBuilder = Future<LayerOptions> Function();

class MapView extends StatefulWidget {
  final String title;
  final double initialZoom;

  /// Parsing method for the polyline data.
  final PolylineLayerBuilder polylineLayerBuilder;

  const MapView({
    Key? key,
    required this.title,
    required this.polylineLayerBuilder,
    this.initialZoom = 13.0,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();
  final _center = LatLng(48.57894, 7.703362);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          FutureBuilder<LayerOptions>(
            future: widget.polylineLayerBuilder(),
            builder: (_, snapshot) {
              final layer = snapshot.data;
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (layer == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  plugins: [NewPolylinePlugin()],
                  center: _center,
                  zoom: widget.initialZoom,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return const Text("© OpenStreetMap contributors");
                    },
                  ),
                  layer,
                ],
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _mapController.move(
                    _mapController.center,
                    _mapController.zoom + 1,
                  ),
                  icon: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () => _mapController.move(
                    _mapController.center,
                    _mapController.zoom - 1,
                  ),
                  icon: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
