import 'exception.dart';

class InternetException extends DomainException {
  InternetException({Object? cause}) : super('No internet connection', cause: cause);
}

class UnknownException extends DomainException {
  UnknownException({Object? cause}) : super('Unknown exception occurred', cause: cause);
}

class ResourceNotFoundException extends DomainException {
  ResourceNotFoundException({Object? cause}) : super('Unable to find requested resource', cause: cause);
}

class UserNotAuthenticatedException extends DomainException {
  UserNotAuthenticatedException({Object? cause}) : super('User is not authenticated', cause: cause);
}