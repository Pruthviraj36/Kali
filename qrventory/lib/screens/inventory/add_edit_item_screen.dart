import 'package:flutter/material.dart';

class AddEditItemScreen extends StatelessWidget {
  const AddEditItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add / Edit Item')),
      body: const Center(child: Text('Form to add or edit item')),
    );
  }
}