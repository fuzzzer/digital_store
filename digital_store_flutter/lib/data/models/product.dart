import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:digital_store_flutter/logic/global_logics/image_transformation.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final int quantity;
  final Image? image;
  final String size;
  final double rating;
  final List<String> categories;
  final String color;
  final double price;
  final String createdAt;
  final String modifiedAt;
  final int? quantityInTheCart;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
    required this.image,
    required this.size,
    required this.rating,
    required this.categories,
    required this.color,
    required this.price,
    required this.createdAt,
    required this.modifiedAt,
    this.quantityInTheCart,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    int? quantity,
    Image? image,
    String? size,
    double? rating,
    List<String>? categories,
    String? color,
    double? price,
    String? createdAt,
    String? modifiedAt,
    int? quantityInTheCart,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      size: size ?? this.size,
      rating: rating ?? this.rating,
      categories: categories ?? this.categories,
      color: color ?? this.color,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      quantityInTheCart: quantityInTheCart ?? this.quantityInTheCart,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'quantity': quantity});
    result.addAll({'image': ''});
    result.addAll({'size': size});
    result.addAll({'rating': rating});
    result.addAll({'categories': categories});
    result.addAll({'color': color});
    result.addAll({'price': price});
    result.addAll({'createdAt': createdAt});
    result.addAll({'modifiedAt': modifiedAt});
    if (quantityInTheCart != null) {
      result.addAll({'quantityInTheCart': quantityInTheCart});
    }

    return result;
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      image: base64ToImage(map['image']),
      size: map['size'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      categories: List<String>.from(map['categories']),
      color: map['color'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] ?? '',
      modifiedAt: map['modifiedAt'] ?? '',
      quantityInTheCart: map['quantityInTheCart']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, quantity: $quantity, image: $image, size: $size, rating: $rating, categories: $categories, color: $color, price: $price, createdAt: $createdAt, modifiedAt: $modifiedAt, quantityInTheCart: $quantityInTheCart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.quantity == quantity &&
        other.image == image &&
        other.size == size &&
        other.rating == rating &&
        listEquals(other.categories, categories) &&
        other.color == color &&
        other.price == price &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.quantityInTheCart == quantityInTheCart;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        quantity.hashCode ^
        image.hashCode ^
        size.hashCode ^
        rating.hashCode ^
        categories.hashCode ^
        color.hashCode ^
        price.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        quantityInTheCart.hashCode;
  }
}
