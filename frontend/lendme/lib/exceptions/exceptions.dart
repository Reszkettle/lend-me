// Base exception
class DomainException implements Exception {
  final String message;

  DomainException(this.message);

  @override
  String toString() {
    return '${runtimeType.toString()}($message)';
  }
}

class InternetException extends DomainException {
  InternetException([String message = 'No internet connection']) : super(message);
}

class ResourceNotFoundException extends DomainException {
  ResourceNotFoundException([String message = 'Unable to find requested resource']) : super(message);
}

class UnknownException extends DomainException {
  UnknownException([String message = 'Unknown failure occurred']) : super(message);
}
