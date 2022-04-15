import 'package:latlong2/latlong.dart';

List<LatLng> coordinatesToLatLngList(List<List<double>> coords) {
  final coordinates = <LatLng>[];
  for (final e in coords) {
    coordinates.add(LatLng(e[1], e[0]));
  }
  return coordinates;
}
