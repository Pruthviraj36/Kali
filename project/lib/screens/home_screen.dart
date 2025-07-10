import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DropNote')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed('/drop'),
              child: const Text('Drop a Note'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/discover'),
              child: const Text('Discover Notes Nearby'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/map'),
              child: const Text('Explore Map'),
            ),
          ],
        ),
      ),
    );
  }
}