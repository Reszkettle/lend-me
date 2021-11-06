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

  static UserInfo fromMap(Map<String, dynamic> map) {
    return UserInfo(
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        phone: map['phone'] as String?,
        email: map['email'] as String?
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email
    };
  }
}