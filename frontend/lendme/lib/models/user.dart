import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/models/user_info.dart';

class User {

  final String uid;
  final String? avatarUrl;
  final DateTime createdAt;
  final UserInfo info;

  User({required this.uid, required this.avatarUrl, required this.createdAt, required this.info});

  factory User.fromJson(Map<String, dynamic> json, String uid) {
    Timestamp t = json['createdAt'] as Timestamp;
    return User(
        uid: uid,
        avatarUrl: json['id'] as String?,
        createdAt: t.toDate(),
        info: UserInfo.fromJson(json['info'])
    );
  }

  @override
  String toString() {
    return 'User{uid: $uid, avatarUrl: $avatarUrl, createdAt: $createdAt, info: $info}';
  }
}