import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/models/rental.dart';

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
      }
      final data = snapshot.docs[0].data();
      final rental = Rental.fromMap(data);
      return rental;
    });
  }
}
