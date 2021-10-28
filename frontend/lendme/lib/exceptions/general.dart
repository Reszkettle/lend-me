import 'exception.dart';

class InternetException extends DomainException {
  InternetException({Object? cause}) : super('No internet connection', cause: cause);
}

class UnknownException extends DomainException {
  UnknownException({Object? cause}) : super('Unknown exception occurred', cause: cause);
}
