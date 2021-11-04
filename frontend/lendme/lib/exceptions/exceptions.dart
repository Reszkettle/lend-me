// Base exception
class DomainException implements Exception {
  final String message;
  final Object? cause;

  DomainException(this.message, {this.cause});

  @override
  String toString() {
    return '${runtimeType.toString()}($message)';
  }
}

class InternetException extends DomainException {
  InternetException({Object? cause}) : super('No internet connection', cause: cause);
}

class UnknownException extends DomainException {
  UnknownException({Object? cause}) : super('Unknown exception occurred', cause: cause);
}

class ResourceNotFoundException extends DomainException {
  ResourceNotFoundException({Object? cause}) : super('Unable to find requested resource', cause: cause);
}
