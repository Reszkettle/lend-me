import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/exceptions/general.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';

class UserRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getUser(String uid) async {
    DocumentSnapshot snapshot = await _firestore
        .collection("users")
        .doc(uid)
        .get();
    Map<String, dynamic>? map = snapshot.data() as Map<String, dynamic>?;
    if(map == null) {
      throw ResourceNotFoundException();
    }
    User user = User.fromJson(map, uid);
    print(user);
    return user;
  }

  Future setUserInfo(String uid, UserInfo info) async {

    Map<String, dynamic> data = {
      'info': info.toJson()
    };

    await _firestore
        .collection("users")
        .doc(uid)
        .update(data);
  }
}
