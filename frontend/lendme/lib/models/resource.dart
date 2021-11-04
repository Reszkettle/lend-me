import 'package:lendme/exceptions/exceptions.dart';

// Wrapper class holing resource or exception
// Mainly to use as stream elements, because it's impossible to push exception to streams
class Resource<T> {
  T ? data;
  DomainException? error;

  Resource({this.data, this.error});

  Resource.success(this.data);
  Resource.error(this.error);
  Resource.loading();

  bool get isLoading => error == null && data == null;
  bool get isSuccess => data != null;
  bool get isError => error != null;

  @override
  String toString() {
    return 'Resource{data: $data, error: $error}';
  }
}