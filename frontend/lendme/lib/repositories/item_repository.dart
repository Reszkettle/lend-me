import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/models/item.dart';

class ItemRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Item?>> getStreamOfCurrentUserItems() {
    return firestore
        .collection('items')
        .where('ownerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((queryDocumentSnapshot) {
        Map<String, dynamic> map = queryDocumentSnapshot.data();
        return Item.fromMap(map);
      }).toList();
    });
  }
}
