import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateNewID() {
  final uuid = Uuid();

  return uuid.v1();
}

String generateSalt() {
  final int length = 32;
  final rand = Random.secure();
  final saltBytesList = List<int>.generate(length, (_) => rand.nextInt(256));
  return base64.encode(saltBytesList);
}

String generateJwt({
  required final String subject,
  required final String issuer,
  required final String secretKey,
  Duration duration = const Duration(seconds: 15),
}) {
  final jwt = JWT(
    {'iat': DateTime.now().millisecondsSinceEpoch},
    subject: subject,
    issuer: issuer,
  );
  return jwt.sign(SecretKey(secretKey), expiresIn: duration);
}
