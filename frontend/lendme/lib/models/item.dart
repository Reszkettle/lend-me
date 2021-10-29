import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String ownerId;
  final Timestamp? createdAt;

  final String? description;
  final String title;

  final String? lentById;
  String? imageUrl;

  Item(
      {this.id,
      required this.ownerId,
      this.createdAt,
      this.description,
      required this.title,
      this.lentById,
      this.imageUrl});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['uid'] as String,
        ownerId: json['id'] as String,
        createdAt: json['createdAt'] as Timestamp,
        description: json['description'] as String?,
        title: json['title'] as String,
        lentById: json['lentById'] as String?,
        imageUrl: json['imageUrl'] as String?);
  }
}
