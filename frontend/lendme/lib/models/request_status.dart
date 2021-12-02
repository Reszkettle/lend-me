class RequestStatus {
  final String _name;

  const RequestStatus._(this._name);

  static const RequestStatus pending = RequestStatus._('pending');
  static const RequestStatus accepted = RequestStatus._('accepted');
  static const RequestStatus rejected = RequestStatus._('rejected');

  @override
  String toString() {
    return _name;
  }

  static RequestStatus fromString(String str) {
    if(str == "pending") {
      return RequestStatus.pending;
    } else if(str == "accepted") {
      return RequestStatus.accepted;
    } else if(str == "rejected") {
      return RequestStatus.rejected;
    } else {
      throw Exception("Invalid request type");
    }
  }

}

