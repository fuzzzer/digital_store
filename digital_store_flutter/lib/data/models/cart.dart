import 'package:flutter/foundation.dart';

import 'package:digital_store_flutter/data/models/product.dart';

class Cart {
  final Map<Product, int> productsInTheCart;

  const Cart({
    required final this.productsInTheCart,
  });

  Cart copyWith({
    Map<Product, int>? productsInTheCart,
  }) {
    return Cart(
      productsInTheCart: productsInTheCart ?? this.productsInTheCart,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'productsInTheCart': productsInTheCart});

    return result;
  }

  factory Cart.fromJson(Map<String, dynamic> map) {
    return Cart(
      productsInTheCart: Map<Product, int>.from(map['productsInTheCart']),
    );
  }

  @override
  String toString() => 'Cart(productsInTheCart: $productsInTheCart)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        mapEquals(other.productsInTheCart, productsInTheCart);
  }

  @override
  int get hashCode => productsInTheCart.hashCode;
}
