import 'package:flutter/material.dart';
import 'package:flutter_map_sample/issue_1111/issue_1111_view.dart';
import 'package:flutter_map_sample/polylines_test/polylines_test_view.dart';

class RootView extends StatelessWidget {
  static const routeName = '/';

  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                PolylinesTestView.routeName,
              ),
              child: const Text('Polylines'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                Issue1111View.routeName,
              ),
              child: const Text('Issue 1111'),
            ),
          ],
        ),
      ),
    );
  }
}
