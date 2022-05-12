import 'dart:convert';

class User {
  String username;
  String password;
  double balance;
  String firstName;
  String lastName;
  String email;
  String birthDate;
  String phoneNumber;
  String adress;
  String sex;

  User({
    required this.username,
    required this.password,
    required this.balance,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.phoneNumber,
    required this.adress,
    required this.sex,
  });

  User copyWith({
    String? username,
    String? password,
    double? balance,
    String? firstName,
    String? lastName,
    String? email,
    String? birthDate,
    String? phoneNumber,
    String? adress,
    String? sex,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      balance: balance ?? this.balance,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      adress: adress ?? this.adress,
      sex: sex ?? this.sex,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'username': username});
    result.addAll({'password': password});
    result.addAll({'balance': balance});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'email': email});
    result.addAll({'birthDate': birthDate});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'adress': adress});
    result.addAll({'sex': sex});

    return result;
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      birthDate: map['birthDate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      adress: map['adress'] ?? '',
      sex: map['sex'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User(username: $username, password: $password, balance: $balance, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, phoneNumber: $phoneNumber, adress: $adress, sex: $sex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.username == username &&
        other.password == password &&
        other.balance == balance &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.phoneNumber == phoneNumber &&
        other.adress == adress &&
        other.sex == sex;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        password.hashCode ^
        balance.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        phoneNumber.hashCode ^
        adress.hashCode ^
        sex.hashCode;
  }
}
