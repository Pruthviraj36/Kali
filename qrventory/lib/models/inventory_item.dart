import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final int minQuantity;
  final String barcode;
  final DateTime updatedAt;
  final String createdBy;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.minQuantity,
    required this.barcode,
    required this.updatedAt,
    required this.createdBy,
  });

  factory InventoryItem.fromMap(String id, Map<String, dynamic> data) {
    return InventoryItem(
      id: id,
      name: data['name'],
      description: data['description'],
      quantity: data['quantity'],
      minQuantity: data['minQuantity'],
      barcode: data['barcode'],
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'minQuantity': minQuantity,
      'barcode': barcode,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
    };
  }
}
