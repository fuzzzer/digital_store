class Category {
  final String id;
  final String title;
  final String description;

  const Category({
    required final this.id,
    required final this.title,
    required final this.description,
  });

  Category copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});

    return result;
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() =>
      'Category(id: $id, title: $title, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;
}
