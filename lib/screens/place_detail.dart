import 'package:favoriteplacesapp/models/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.network(
              place.file,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ));
  }
}
