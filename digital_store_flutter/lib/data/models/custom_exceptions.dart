class InvalidTokenException implements Exception {
  final String reason;
  const InvalidTokenException(final this.reason);
}

class UnknownException implements Exception {
  final String reason;
  const UnknownException(final this.reason);
}
