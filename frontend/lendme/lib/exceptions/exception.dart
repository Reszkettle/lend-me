class DomainException implements Exception {

  final String message;
  final Object? cause;

  DomainException(this.message, {this.cause});

  @override
  String toString() {
    return message;
  }
}
