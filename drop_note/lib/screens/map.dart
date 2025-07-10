import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfoScreen extends StatefulWidget {
  const LocationInfoScreen({super.key});

  @override
  State<LocationInfoScreen> createState() => _LocationInfoScreenState();
}

class _LocationInfoScreenState extends State<LocationInfoScreen> {
  String latitude = 'Fetching...';
  String longitude = 'Fetching...';
  LatLng? currentLatLng;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    await Permission.location.request();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      currentLatLng = LatLng(position.latitude, position.longitude);
    });

    if (mapController != null && currentLatLng != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLatLng!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Info"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildInfoCard("Latitude", latitude, Icons.my_location),
          _buildInfoCard("Longitude", longitude, Icons.place),
          const SizedBox(height: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: (controller) => mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: currentLatLng!,
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: currentLatLng!,
                    infoWindow: const InfoWindow(title: "You Are Here"),
                  )
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _fetchLocation,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }
}