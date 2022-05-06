class NotFoundException implements Exception {
  String reason;
  NotFoundException(this.reason);
}

class InvalidInputException implements Exception {
  String reason;
  InvalidInputException(this.reason);
}

class ExistentIdentifierException implements Exception {
  String reason;
  ExistentIdentifierException(this.reason);
}

class NotEnoughMoneyException implements Exception {
  String reason;
  NotEnoughMoneyException(this.reason);
}

class ProductNotAvailableException implements Exception {
  String reason;
  ProductNotAvailableException(this.reason);
}
