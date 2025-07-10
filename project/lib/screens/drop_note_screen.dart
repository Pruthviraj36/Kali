import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class DropNoteScreen extends StatefulWidget {
  const DropNoteScreen({super.key});

  @override
  State<DropNoteScreen> createState() => _DropNoteScreenState();
}

class _DropNoteScreenState extends State<DropNoteScreen> {
  final TextEditingController messageController = TextEditingController();
  String locationStatus = 'Location not fetched yet';

  Future<void> _dropNote() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => locationStatus = 'Location services are disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => locationStatus = 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => locationStatus = 'Location permissions are permanently denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      locationStatus = 'Dropped note at: ${position.latitude}, ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drop a Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Secret Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _dropNote,
              child: const Text('Drop Note at My Location'),
            ),
            const SizedBox(height: 20),
            Text(locationStatus),
          ],
        ),
      ),
    );
  }
}