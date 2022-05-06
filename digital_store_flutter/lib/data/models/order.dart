class Order {
  final String id;
  final int quantity;
  final double price;
  final double totalPrice;
  final String createdAt;

  const Order({
    required this.id,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.createdAt,
  });

  Order copyWith({
    String? id,
    int? quantity,
    double? price,
    double? totalPrice,
    String? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'quantity': quantity});
    result.addAll({'price': price});
    result.addAll({'totalPrice': totalPrice});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, quantity: $quantity, price: $price, totalPrice: $totalPrice, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.quantity == quantity &&
        other.price == price &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        totalPrice.hashCode ^
        createdAt.hashCode;
  }
}
