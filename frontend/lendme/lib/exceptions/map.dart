import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/exceptions/general.dart';

DomainException mapToDomainException(Object e) {
  if(e is FirebaseException) {
    if(e.message != null) {
      return DomainException(e.message!);
    }
    else {
      return UnknownException(cause: e);
    }
  }
  else {
    return UnknownException(cause: e);
  }
}
