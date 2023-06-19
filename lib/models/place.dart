import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

class PlaceLocation {
  PlaceLocation({required this.address, required this.lat, required this.lng});

  final double lat;
  final double lng;
  final String address;
}

class Place {
  Place({required this.title, required this.file, required this.placeLocation})
      : id = uuid.v4();
  final String id;
  final String title;
  // final File file;
  final String file;
  final PlaceLocation placeLocation;
}
