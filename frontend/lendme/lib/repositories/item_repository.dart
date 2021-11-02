import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/models/item.dart';

class ItemRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final itemsRef =
      FirebaseFirestore.instance.collection("items").withConverter<Item>(
            fromFirestore: (snapshot, _) => Item.fromJson(snapshot.data()!),
            toFirestore: (item, _) => item.toJson(),
          );

  Stream<QuerySnapshot<Item>> getListOfCurrentUserItems() {
    return itemsRef
        .where('ownerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots();
  }
}
