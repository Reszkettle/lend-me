import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/request.dart';
import 'package:cloud_functions/cloud_functions.dart';

class RequestRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Stream<List<Request?>> getStreamOfCurrentUserRequests() {
    return firestore
        .collection('requests')
        .where('receivers', arrayContains: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((queryDocumentSnapshot) {
        Map<String, dynamic> map = queryDocumentSnapshot.data();
        return Request.fromMap(map, queryDocumentSnapshot.id);
      }).toList();
    });
  }

  Future addRequest(Request request) async {
    try {
      await firestore.collection('requests').add(request.toMap());
    } on PlatformException catch (exception) {
      throw UnknownException(exception.message ??
          'Something went wrong while creating transfer request');
    }
  }

  Stream<Request?> getRequestStream(String requestId) {
    return firestore
        .collection('requests')
        .doc(requestId)
        .snapshots()
        .map((snapshot) {
      final r = Request.fromMap(snapshot.data(), snapshot.id);
      return r;
    });
  }

  Future acceptRequest(String requestId, String? message) async {
    try {
      HttpsCallable acceptFunction =
          FirebaseFunctions.instance.httpsCallable('requests-accept');
      final parameters = <String, dynamic>{
        'requestId': requestId,
        'message': message,
      };
      await acceptFunction(parameters);
    } on FirebaseFunctionsException catch (e) {
      throw DomainException(e.message ?? "Unknown exception");
    } catch (e) {
      throw UnknownException();
    }
  }

  Future rejectRequest(String requestId, String? message) async {
    try {
      HttpsCallable rejectFunction =
          FirebaseFunctions.instance.httpsCallable('requests-reject');
      final parameters = <String, dynamic>{
        'requestId': requestId,
        'message': message,
      };
      await rejectFunction(parameters);
    } on FirebaseFunctionsException catch (e) {
      throw DomainException(e.message ?? "Unknown exception");
    } catch (e) {
      throw UnknownException();
    }
  }

  Stream<bool> userHasPendingRequestsForThisItemStream(String itemId) {
    return firestore
        .collection('requests')
        .where('issuerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('itemId', isEqualTo: itemId)
        .where('status', isEqualTo: "pending")
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
    }
}
