import 'package:cloud_firestore/cloud_firestore.dart';

class Rental {
  final String? id;
  final String borrowerId;
  final String ownerId;
  final String itemId;
  final Timestamp endDate;
  final Timestamp startDate;
  final String status;
  final String? borrowerFullname;
  final String? ownerFullname;

  Rental(
      {this.id,
      this.borrowerFullname,
      this.ownerFullname,
      required this.borrowerId,
      required this.ownerId,
      required this.itemId,
      required this.endDate,
      required this.startDate,
      required this.status});

  static Rental fromMap(Map<String, dynamic> json) {
    return Rental(
        id: json['id'] as String?,
        ownerId: json['ownerId'] as String,
        borrowerFullname: json['borrowerFullname'] as String?,
        ownerFullname: json['ownerFullname'] as String?,
        itemId: json['itemId'] as String,
        borrowerId: json['borrowerId'] as String,
        status: json['status'] as String,
        startDate: json['startDate'] as Timestamp,
        endDate: json['endDate'] as Timestamp);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'itemId': itemId,
      'borrowerId': borrowerId,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'borrowerFullname': borrowerFullname,
      'ownerFullname': ownerFullname
    };
  }
}
