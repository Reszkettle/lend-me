import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';

class UserRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection("users")
          .doc(uid)
          .get();
      Map<String, dynamic>? map = snapshot.data() as Map<String, dynamic>?;
      if(map == null) {
        throw ResourceNotFoundException();
      }
      User user = User.fromMap(map, uid);
      return user;
    } catch (e) {
      throw UnknownException();
    }
  }

  Stream<Resource<User>> getUserStream(String uid) {
    try {
      return _firestore
          .collection("users")
          .doc(uid)
          .snapshots()
      .map((snapshot) {
        Map<String, dynamic>? map = snapshot.data();
        if(map == null) {
          return Resource.error(ResourceNotFoundException());
        }
        User user = User.fromMap(map, uid);
        return Resource.success(user);
      });
    } catch (e) {
      throw UnknownException();
    }
  }

  Future setUserInfo(String uid, UserInfo userInfo) async {
    try {
      Map<String, dynamic> data = {
        'info': userInfo.toMap()
      };

      await _firestore.runTransaction((transaction) async {
        DocumentReference ref = _firestore.collection("users").doc(uid);
        transaction.update(ref, data);
      });
    } catch (e) {
      throw UnknownException();
    }
  }

}
