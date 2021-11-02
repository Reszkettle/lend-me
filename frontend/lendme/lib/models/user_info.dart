class UserInfo {

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  UserInfo({this.firstName, this.lastName, this.phone, this.email});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email
    };
  }

  @override
  String toString() {
    return 'UserInfo{firstName: $firstName, lastName: $lastName, phone: $phone, email: $email}';
  }
}