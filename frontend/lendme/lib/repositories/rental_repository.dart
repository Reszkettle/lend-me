import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:rxdart/rxdart.dart';

import 'package:lendme/exceptions/exceptions.dart';

class RentalRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Rental?> getItemActiveRentalStream(String itemId) {
    return firestore
        .collection('rentals')
        .where('status', isEqualTo: 'pending')
        .where('itemId', isEqualTo: itemId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      if (snapshot.docs.length > 1) {
        log('Inconsistent database state! Item $itemId is rented multiple times!');
      }s
      final data = snapshot.docs[0].data();
      data['id']=snapshot.docs[0].id;
      final rental = Rental.fromMap(data);
      return rental;
    });
  }

  Stream<List<ItemRental>> getStreamOfBorrowedItemsWithRentals(String uid) {
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
          .collection('items')
          .doc(queryDocSnapshot.data()['itemId'])
          .snapshots()
          .map<Item>((document) => Item.fromMap(document.data()!, document.id)!);
      return Rx.combineLatest2<Item, Rental, ItemRental>(
          item, rental, (item, rental) => ItemRental(item, rental));
    }))
        .switchMap((observables) {
      return observables.isNotEmpty
          ? Rx.combineLatestList(observables)
          : Stream.value([]);
    });
  }

  Stream<List<ItemRental>> getStreamOfLentItemsWithRentals(String uid) {
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
          .collection('items')
          .doc(queryDocSnapshot.data()['itemId'])
          .snapshots()
          .map<Item>((document) => Item.fromMap(document.data()!, document.id)!);
      return Rx.combineLatest2<Item, Rental, ItemRental>(
          item, rental, (item, rental) => ItemRental(item, rental));
    }))
        .switchMap((observables) {
      return observables.isNotEmpty
          ? Rx.combineLatestList(observables)
          : Stream.value([]);
    });
  }


  Future addBorrow(Rental rental) async {
    try {
      CollectionReference rentals =
      FirebaseFirestore.instance.collection('rentals');
      await rentals.add(rental.toMap());
    } catch (e) {
      throw UnknownException();
    }
  }


}
