class InvalidTokenException implements Exception {
  final String reason;
  const InvalidTokenException(final this.reason);
}

class InvalidRefreshTokenException implements Exception {
  final String reason;
  const InvalidRefreshTokenException(final this.reason);
}

class InvalidTokenRecievedException implements Exception {
  final String reason;
  const InvalidTokenRecievedException(final this.reason);
}

class MessageException implements Exception {
  final String reason;
  const MessageException(final this.reason);
}
