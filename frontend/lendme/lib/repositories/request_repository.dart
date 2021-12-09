import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
