import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'screens/drop_note_screen.dart';
import 'screens/discover_notes_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const DropNoteApp());
}

class DropNoteApp extends StatelessWidget {
  const DropNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DropNote',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/drop', page: () => const DropNoteScreen()),
        GetPage(name: '/discover', page: () => const DiscoverNotesScreen()),
        GetPage(name: '/map', page: () => const MapScreen()),
      ],
    );
  }
}
