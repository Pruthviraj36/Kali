import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DiscoverNotesScreen extends StatefulWidget {
  const DiscoverNotesScreen({super.key});

  @override
  State<DiscoverNotesScreen> createState() => _DiscoverNotesScreenState();
}

class _DiscoverNotesScreenState extends State<DiscoverNotesScreen> {
  Position? _userPosition;

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() => _userPosition = position);
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Notes')),
      body: _userPosition == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Note ${index + 1}'),
                  subtitle: Text(
                    'Your location: ${_userPosition!.latitude.toStringAsFixed(4)}, ${_userPosition!.longitude.toStringAsFixed(4)}',
                  ),
                );
              },
            ),
    );
  }
}