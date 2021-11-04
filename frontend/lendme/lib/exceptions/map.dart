import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendme/exceptions/exceptions.dart';

DomainException mapToDomainException(Object e) {
  if(e is FirebaseException) {
    return _mapFirebaseException(e);
  }
  else {
    return _mapNonFirebaseException(e);
  }
}

DomainException _mapFirebaseException(FirebaseException e) {
  print('Mapping firebase exception: $e (code: ${e.code})');

  switch(e.code) {
    case 'network-request-failed':
    case 'unavailable':
      return InternetException();
  }

  // Fallback
  return UnknownException(cause: e);
}

DomainException _mapNonFirebaseException(Object e) {
  print('Mapping non firebase exception: $e');
  return UnknownException(cause: e);
}