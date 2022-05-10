class InvalidTokenException implements Exception {
  final String reason;
  const InvalidTokenException(final this.reason);
}

class UnknownException implements Exception {
  final String reason;
  const UnknownException(final this.reason);
}

class NotFoundException implements Exception {
  final String reason;
  const NotFoundException(final this.reason);
}

class MessageException implements Exception {
  final String reason;
  const MessageException(final this.reason);
}
