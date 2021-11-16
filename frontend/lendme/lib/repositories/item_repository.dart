import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:uuid/uuid.dart';

class ItemRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  var uuid = Uuid();
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

  Future addItem(Item item) async {
    try{
      CollectionReference items = FirebaseFirestore.instance.collection('items');
      await items.add(item.toMap());
    } catch (e) {
      throw UnknownException();
    }
  }

  Future addImage(localImagePath) async {
    String downloadUrl;
    if (localImagePath != null) {
      try {
        var snapshot = await storage.ref().child('images/items/' + uuid.v4()).putFile(localImagePath);
        downloadUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        throw UnknownException();
      }

      return downloadUrl;
    }
  }
}
