import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/models/request_status.dart';
import 'package:lendme/models/request_type.dart';

class Request {
  String? id;
  Timestamp endDate;
  String issuerId;
  String itemId;
  String? requestMessage;
  String? responseMessage;
  String? title;
  String? subtitle;
  RequestStatus status;
  RequestType type;

  Request(
      {this.id,
      required this.endDate,
      required this.issuerId,
      required this.itemId,
      this.requestMessage,
      this.responseMessage,
      this.title,
      this.subtitle,
      required this.status,
      required this.type});

  static Request? fromMap(Map<String, dynamic>? json, String? id) {
    if (json == null) {
      return null;
    }
    return Request(
        id: id,
        endDate: json['endDate'] as Timestamp,
        issuerId: json['issuerId'] as String,
        itemId: json['itemId'] as String,
        requestMessage: json['requestMessage'] as String?,
        responseMessage: json['responseMessage'] as String?,
        status: RequestStatus.fromString(json['status']),
        type: RequestType.fromString(json['type']),
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'endDate': endDate,
      'issuerId': issuerId,
      'itemId': itemId,
      'requestMessage': requestMessage,
      'responseMessage': responseMessage,
      'title': title,
      'subtitle': subtitle,
      'status': status.toString(),
      'type': type.toString(),
    };
  }
}
