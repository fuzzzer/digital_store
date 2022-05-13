import 'dart:convert';

class Tokens {
  String accessToken;
  String refreshToken;

  Tokens({
    required this.accessToken,
    required this.refreshToken,
  });

  Tokens copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Tokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'accessToken': accessToken});
    result.addAll({'refreshToken': refreshToken});

    return result;
  }

  factory Tokens.fromMap(Map<String, dynamic> map) {
    return Tokens(
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tokens.fromJson(String source) => Tokens.fromMap(json.decode(source));

  @override
  String toString() =>
      'Tokens(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tokens &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
