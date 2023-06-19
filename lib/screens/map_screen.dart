import 'package:favoriteplacesapp/Constants/appConstants.dart';
import 'package:favoriteplacesapp/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    super.key,
    this.isSelecting = true,
  });

  final bool isSelecting;
  LatLng point = LatLng(51.499322, -0.199558);

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(widget.point);
              },
              icon: Icon(Icons.save),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onTap: widget.isSelecting == true
                  ? (tapPosition, point1) {
                      setState(() {
                        widget.point = point1;
                        print(widget.point);
                      });
                    }
                  : null,
              minZoom: 5,
              maxZoom: 30,
              zoom: 16,
              center: AppConstants.myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/kuberm/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 100,
                    height: 100,
                    point: widget.point,
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.navigation),
      // ),
    );
  }
}
