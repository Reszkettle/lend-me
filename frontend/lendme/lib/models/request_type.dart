class RequestType {
  final String _name;

  const RequestType._(this._name);

  static const RequestType borrow = RequestType._('borrow');
  static const RequestType extend = RequestType._('extend');
  static const RequestType transfer = RequestType._('transfer');

  @override
  String toString() {
    return _name;
  }

  static RequestType fromString(String str) {
    if(str == "borrow") {
      return RequestType.borrow;
    } else if(str == "extend") {
      return RequestType.extend;
    } else if(str == "transfer") {
      return RequestType.transfer;
    } else {
      throw Exception("Invalid request type");
    }
  }

}

