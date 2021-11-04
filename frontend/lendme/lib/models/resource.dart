import 'package:lendme/exceptions/exceptions.dart';

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