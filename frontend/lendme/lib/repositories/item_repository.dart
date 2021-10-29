import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/models/item.dart';

class ItemRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  Future<List<Item>> getListOfCurrentUserItems() async {
    final String currentUserId = '12345';

    QuerySnapshot snapshot = await firebaseStore
        .collection("items")
        .where('ownerId', isEqualTo: currentUserId)
        .get();

    List<Item> items = [];

    for (var element in snapshot.docs) {
      print(element.data());
      items.add(Item.fromJson(element.data() as Map<String, dynamic>));
    }

    return items;
  }
}
