import 'dart:convert';

import 'package:favoriteplacesapp/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.placeLocation});

  final void Function(PlaceLocation placeLocation) placeLocation;
  @override
  State<LocationInput> createState() {
    return _LocationInputSTate();
  }
}

class _LocationInputSTate extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingCurrentLocation = false;

  String get locationImage {
    final lat = _pickedLocation!.lat;
    final lng = _pickedLocation!.lng;
    return
        // 'https://maptoolkit.p.rapidapi.com/staticmap?center=$lat%2C$lng&zoom=11&size=640x480&maptype=toursprung-terrain&format=png';
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/$lng,$lat,12.26,0/400x400?access_token=pk.eyJ1Ijoia3ViZXJtIiwiYSI6ImNsajJwZGx0YjFhaTgzcXQ4M2E0NzBxbW8ifQ.lTuvjewt2c8ZioREoK8B8A';
  }

  // void _getCurrentLocationImage() async {
  //   final url1 = Uri.https(locationImage);

  //   final url = Uri.parse(locationImage);
  //   final response = await http.get(
  //     headers: {
  //       'X-RapidAPI-Key': '1cbcc40ba0msh093f50965a69601p1de1c7jsn621c959700a8',
  //       'X-RapidAPI-Host': 'maptoolkit.p.rapidapi.com',
  //     },
  //     url1,
  //   );
  //   print(response.statusCode);
  // }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingCurrentLocation = true;
    });
    locationData = await location.getLocation();

    // final url = Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.latitude}&key=AIzaSyBK5pv56usZuOLJZJksI_9iJGcrUtcPp4U');
    // final response = await http.get(url);
    //
    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${locationData.longitude},${locationData.latitude}.json?access_token=pk.eyJ1Ijoia3ViZXJtIiwiYSI6ImNsajJwZGx0YjFhaTgzcXQ4M2E0NzBxbW8ifQ.lTuvjewt2c8ZioREoK8B8A');

    final response = await http.get(url);

    final resData = json.decode(response.body);
    print(resData['features'][0]['place_name']);

    setState(() {
      _pickedLocation = PlaceLocation(
          address: resData['Results'][0]['address'],
          lat: locationData.latitude!,
          lng: locationData.longitude!);
      _isGettingCurrentLocation = false;
    });
    print(locationData.longitude);
    print(locationData.latitude);

    widget.placeLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget priviewContent = Text(
      'No location choosen yet',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_isGettingCurrentLocation) {
      priviewContent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      priviewContent = Image.network(
        width: double.infinity,
        fit: BoxFit.cover,
        locationImage,
      );
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: priviewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text('Select on map'),
            ),
          ],
        ),
      ],
    );
  }
}
