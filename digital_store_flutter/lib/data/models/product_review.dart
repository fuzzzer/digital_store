class ProductReview {
  final String userId;
  final String productId;
  final String rating;
  final String review;
  final String createdAt;
  final String modifiedAt;

  const ProductReview({
    required final this.userId,
    required final this.productId,
    required final this.rating,
    required final this.review,
    required final this.createdAt,
    required final this.modifiedAt,
  });

  ProductReview copyWith({
    String? userId,
    String? productId,
    String? rating,
    String? review,
    String? createdAt,
    String? modifiedAt,
  }) {
    return ProductReview(
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'productId': productId});
    result.addAll({'rating': rating});
    result.addAll({'review': review});
    result.addAll({'createdAt': createdAt});
    result.addAll({'modifiedAt': modifiedAt});

    return result;
  }

  factory ProductReview.fromJson(Map<String, dynamic> map) {
    return ProductReview(
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      rating: map['rating'] ?? '',
      review: map['review'] ?? '',
      createdAt: map['createdAt'] ?? '',
      modifiedAt: map['modifiedAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ProductReview(userId: $userId, productId: $productId, rating: $rating, review: $review, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductReview &&
        other.userId == userId &&
        other.productId == productId &&
        other.rating == rating &&
        other.review == review &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        productId.hashCode ^
        rating.hashCode ^
        review.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode;
  }
}
