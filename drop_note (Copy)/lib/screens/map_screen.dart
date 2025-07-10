import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LocationData? currentLocation;
  final Location location = Location();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getLocation();
      // _loadNotes();
    });
    _getLocation();
  }

  Future<void> _getLocation() async {
    final loc = await location.getLocation();
    setState(() {
      currentLocation = loc;
    });
  }

  void _addNote(LatLng position) async {
    String? note = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text("Add Note"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter note text"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text("Add"),
            ),
          ],
        );
      },
    );

    if (note != null && note.isNotEmpty) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(position.toString()),
            position: position,
            infoWindow: InfoWindow(title: note),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Drop Note Map")),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          zoom: 15,
        ),
        myLocationEnabled: true,
        markers: _markers,
        onTap: _addNote,
      ),
    );
  }
}
