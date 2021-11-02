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
}