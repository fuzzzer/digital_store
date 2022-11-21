import 'dart:convert';

class FallibleMethodResponse<T> {
  final bool isSuccessful;
  final String notificationMessage;
  final T? type;

  FallibleMethodResponse({
    required this.isSuccessful,
    required this.notificationMessage,
    this.type,
  });

  FallibleMethodResponse<T> copyWith({
    bool? didExceptionHappen,
    String? notificationMessage,
    T? type,
  }) {
    return FallibleMethodResponse<T>(
      isSuccessful: didExceptionHappen ?? this.isSuccessful,
      notificationMessage: notificationMessage ?? this.notificationMessage,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'didExceptionHappen': isSuccessful,
      'notificationMessage': notificationMessage,
    };
  }

  factory FallibleMethodResponse.fromMap(Map<String, dynamic> map) {
    return FallibleMethodResponse<T>(
      isSuccessful: map['didExceptionHappen'] as bool,
      notificationMessage: map['notificationMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FallibleMethodResponse.fromJson(String source) =>
      FallibleMethodResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExceptionToWidgetData(didExceptionHappen: $isSuccessful, notificationMessage: $notificationMessage, type: $type)';

  @override
  bool operator ==(covariant FallibleMethodResponse<T> other) {
    if (identical(this, other)) return true;

    return other.isSuccessful == isSuccessful &&
        other.notificationMessage == notificationMessage &&
        other.type == type;
  }

  @override
  int get hashCode =>
      isSuccessful.hashCode ^ notificationMessage.hashCode ^ type.hashCode;
}
