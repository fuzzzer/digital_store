class User {
  String username;
  String password;
  double balance;
  String? firstName;
  String? lastName;
  String email;
  String? birthDate;
  String? phoneNumber;
  String? address;
  String? sex;

  User({
    required this.username,
    required this.password,
    required this.balance,
    this.firstName,
    this.lastName,
    required this.email,
    this.birthDate,
    this.phoneNumber,
    this.address,
    this.sex,
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
    String? address,
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
      address: address ?? this.address,
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
    result.addAll({'address': address});
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
      address: map['address'] ?? '',
      sex: map['sex'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User(username: $username, password: $password, balance: $balance, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, phoneNumber: $phoneNumber, address: $address, sex: $sex)';
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
        other.address == address &&
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
        address.hashCode ^
        sex.hashCode;
  }
}
