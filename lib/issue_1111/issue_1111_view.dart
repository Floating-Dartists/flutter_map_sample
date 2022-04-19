import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class Issue1111View extends StatelessWidget {
  static const routeName = '/issue_1111';

  const Issue1111View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue 1111')),
      body: InkWell(
        onTap: () => print('Tapped on the map'),
        child: AbsorbPointer(
          child: FlutterMap(
            options: MapOptions(),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
