class UserInfo {

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  UserInfo({this.firstName, this.lastName, this.phone, this.email});

  bool isFilled() {
    return firstName != null && lastName != null && phone != null && email != null;
  }

  @override
  String toString() {
    return 'UserInfo{firstName: $firstName, lastName: $lastName, phone: $phone, email: $email}';
  }
}