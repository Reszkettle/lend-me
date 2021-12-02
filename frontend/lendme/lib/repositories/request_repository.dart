import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/models/request.dart';

class RequestRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Request?> getRequestStream(String requestId) {
    return firestore
        .collection('requests')
        .doc(requestId)
        .snapshots()
        .map((snapshot) {
          print("Snapshot: ${snapshot.data()}");
          final r = Request.fromMap(snapshot.data(), snapshot.id);
          return r;
      });
  }

}
