import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';

class UserRepository {

  final fa.FirebaseAuth _auth = fa.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Stream<User?> getUserStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
    .map((snapshot) {
      Map<String, dynamic>? map = snapshot.data();
      if(map == null) {
        return null;
      }
      User user = User.fromMap(map, uid);
      return user;
    });
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

  Future setUserAvatar(File? avatarFile) async {
    try {
      final uid = _auth.currentUser?.uid;
      if(uid == null) {
        throw UserNotLoggedException();
      }
      final reference = _storage.ref().child('images/avatars/$uid');
      String? avatarUrl;
      if(avatarFile != null) {
        var snapshot = await reference.putFile(avatarFile);
        avatarUrl = await snapshot.ref.getDownloadURL();
      } else {
        await reference.delete();
        avatarUrl = null;
      }
      _firestore.collection("users").doc(uid).update({
        'avatarUrl': avatarUrl
      });
    } catch (e) {
      throw UnknownException();
    }
  }

}
