class InvalidTokenException implements Exception {
  final String reason;
  const InvalidTokenException(this.reason);
}

class InvalidRefreshTokenException implements Exception {
  final String reason;
  const InvalidRefreshTokenException(this.reason);
}

class InvalidTokenRecievedException implements Exception {
  final String reason;
  const InvalidTokenRecievedException(this.reason);
}

class MessageException implements Exception {
  final String reason;
  const MessageException(this.reason);
}
