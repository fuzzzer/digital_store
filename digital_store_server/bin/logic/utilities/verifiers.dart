import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

dynamic verifyJwt(final String token, final String secretKey) {
  try {
    return JWT.verify(token, SecretKey(secretKey));
  } on JWTExpiredError {
    //do something
  } on JWTError {
    //do something
  }
}
