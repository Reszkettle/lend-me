import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/item_rentals.dart';
import 'package:lendme/models/rental.dart';
import 'package:rxdart/rxdart.dart';

class RentalRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ItemRentals>> getStreamOfBorrowedItemsWithRentals(String uid) {
    return firestore
        .collection('rentals')
        .where('borrowerId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((queryDocSnapshot) {
              Stream<Rental> rental = Stream.value(queryDocSnapshot)
                  .map<Rental>((document) => Rental.fromMap(document.data()));
              Stream<Item> item = firestore
                  .collection('item')
                  .doc(queryDocSnapshot.data()['itemId'])
                  .snapshots()
                  .map<Item>((document) => Item.fromMap(document.data()!));
              return Rx.combineLatest2<Item, Rental, ItemRentals>(
                  item, rental, (item, rental) => ItemRentals(item, rental));
            }))
        .switchMap((observables) {
      return observables.isNotEmpty
          ? Rx.combineLatestList(observables)
          : Stream.value([]);
    });
  }

  Stream<List<ItemRentals>> getStreamOfLentItemsWithRentals(String uid) {
    return firestore
        .collection('rentals')
        .where('ownerId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((queryDocSnapshot) {
              Stream<Rental> rental = Stream.value(queryDocSnapshot)
                  .map<Rental>((document) => Rental.fromMap(document.data()));
              Stream<Item> item = firestore
                  .collection('item')
                  .doc(queryDocSnapshot.data()['itemId'])
                  .snapshots()
                  .map<Item>((document) => Item.fromMap(document.data()!));
              return Rx.combineLatest2<Item, Rental, ItemRentals>(
                  item, rental, (item, rental) => ItemRentals(item, rental));
            }))
        .switchMap((observables) {
      return observables.isNotEmpty
          ? Rx.combineLatestList(observables)
          : Stream.value([]);
    });
  }

  Future<DateTime?> getActiveBorrowStartDateForItem(String itemId) async {
    try {
      return await firestore
          .collection('rentals')
          .where('itemId', isEqualTo: itemId)
          .where('status', isEqualTo: 'pending')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          Map<String, dynamic> data = value.docs.single.data();
          return (data['startDate'] as Timestamp).toDate();
        } else {
          throw ResourceNotFoundException();
        }
      });
    } catch (e) {
      throw UnknownException();
    }
  }
}
