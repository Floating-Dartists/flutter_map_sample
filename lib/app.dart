import 'package:flutter/material.dart';
import 'package:flutter_map_sample/issue_1111/issue_1111_view.dart';
import 'package:flutter_map_sample/polylines_test/map_view.dart';
import 'package:flutter_map_sample/polylines_test/polylines_test_view.dart';
import 'package:flutter_map_sample/root_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      showPerformanceOverlay: true,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: RootView.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RootView.routeName:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const RootView(),
            );
          case PolylinesTestView.routeName:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PolylinesTestView(),
            );
          case MapView.routeName:
            final args = settings.arguments as MapViewArgs;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => MapView(
                title: args.title,
                polylineLayerBuilder: args.polylineLayerBuilder,
                initialZoom: args.initialZoom,
              ),
            );
          case Issue1111View.routeName:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const Issue1111View(),
            );
          default:
            return null;
        }
      },
    );
  }
}
