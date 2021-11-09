import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/models/user_info.dart';

class User {

  final String uid;
  final String? avatarUrl;
  final DateTime createdAt;
  final UserInfo info;

  User({required this.uid, required this.avatarUrl, required this.createdAt, required this.info});

  @override
  String toString() {
    return 'User{uid: $uid, avatarUrl: $avatarUrl, createdAt: $createdAt, info: $info}';
  }

  static User fromMap(Map<String, dynamic> map, String uid) {
    Timestamp t = map['createdAt'] as Timestamp;
    return User(
        uid: uid,
        avatarUrl: map['avatarUrl'] as String?,
        createdAt: t.toDate(),
        info: UserInfo.fromMap(map['info'])
    );
  }
}