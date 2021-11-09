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

  static Item fromMap(Map<String, dynamic> json) {
    return Item(
        id: json['uid'] as String?,
        ownerId: json['ownerId'] as String,
        createdAt: json['createdAt'] as Timestamp,
        description: json['description'] as String?,
        title: json['title'] as String,
        lentById: json['lentById'] as String?,
        imageUrl: json['imageUrl'] as String?);
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'createdAt': createdAt,
      'description': description,
      'title': title,
      'lentById': lentById,
      'imageUrl': imageUrl
    };
  }
}
