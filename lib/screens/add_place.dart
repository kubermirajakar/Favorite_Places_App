import 'package:favoriteplacesapp/models/place.dart';
import 'package:favoriteplacesapp/providers/user_places.dart';
import 'package:favoriteplacesapp/widgets/image_input.dart';
import 'package:favoriteplacesapp/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _addPlaceScreenState();
  }
}

class _addPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _textController = TextEditingController();
  String? _selectedImage;
  PlaceLocation? placeLocation;

  void _savePlace() {
    final _enteredTitle = _textController.text;
    if (_enteredTitle.isEmpty ||
        _selectedImage == null ||
        placeLocation == null) {
      print('every thing is null');
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(_enteredTitle, _selectedImage!, placeLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _textController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 8,
            ),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            LocationInput(
              onSelectPlaceLocation: (onSelectPlaceLocation) {
                placeLocation = onSelectPlaceLocation;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
