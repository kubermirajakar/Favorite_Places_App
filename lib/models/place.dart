import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Place {
  Place({required this.title, required this.file}) : id = uuid.v4();
  final String id;
  final String title;
  // final File file;
  final String file;
}
