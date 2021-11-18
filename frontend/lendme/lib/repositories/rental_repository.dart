import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lendme/exceptions/exceptions.dart';

class RentalRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
