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

  var uuid = const Uuid();

  Stream<List<Item?>> getStreamOfCurrentUserItems() {
    return firestore
        .collection('items')
        .where('ownerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((queryDocumentSnapshot) {
        Map<String, dynamic> map = queryDocumentSnapshot.data();
        return Item.fromMap(map, queryDocumentSnapshot.id);
      }).toList();
    });
  }

  Stream<List<Item?>> getStreamOfLentItems() {
    return firestore
        .collection('items')
        .where('ownerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('lentById', isNull: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((queryDocumentSnapshot) {
        Map<String, dynamic> map = queryDocumentSnapshot.data();
        return Item.fromMap(map, queryDocumentSnapshot.id);
      }).toList();
    });
  }

  Stream<List<Item?>> getStreamOfBorrowedItems() {
    return firestore
        .collection('items')
        .where('available', isEqualTo: false)
        .where('lentById', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((queryDocumentSnapshot) {
        Map<String, dynamic> map = queryDocumentSnapshot.data();
        map['id'] = queryDocumentSnapshot.id;
        return Item.fromMap(map, queryDocumentSnapshot.id);
      }).toList();
    });
  }

  Stream<Item?> getItemStream(String itemId) {
    return firestore
        .collection('items')
        .doc(itemId)
        .snapshots()
        .map((snapshot) {
          return Item.fromMap(snapshot.data(), snapshot.id);
      });
  }

  Future addItem(Item item) async {
    try {
      CollectionReference items =
          FirebaseFirestore.instance.collection('items');
      await items.add(item.toMap());
    } catch (e) {
      throw UnknownException();
    }
  }

  Future<void> deleteItem(itemId) {
    return firestore
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Future addImage(localImagePath) async {
    String downloadUrl;
    if (localImagePath != null) {
      try {
        var snapshot = await storage
            .ref()
            .child('images/items/' + uuid.v4())
            .putFile(localImagePath);
        downloadUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        throw UnknownException();
      }
      return downloadUrl;
    }
  }
}
