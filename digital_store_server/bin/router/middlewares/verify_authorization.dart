import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../logic/utilities/verifiers.dart';

Middleware handleAuthorization(final String secretKey) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authorizationHeader = request.headers['authorization'];
      JWT? jwt;

      try {
        if (authorizationHeader != null &&
            authorizationHeader.startsWith('Bearer ')) {
          final token = authorizationHeader.substring(7);
          jwt = verifyJwt(token, secretKey); // this will be null or jwt payload
        }
      } catch (e) {}

      final updatedRequest = request.change(context: {
        'authorizationDetails': jwt,
      });
      return await innerHandler(updatedRequest);
    };
  };
}

Middleware checkAuthorization() {
  return createMiddleware(requestHandler: (Request request) {
    if (request.context['authorizationDetails'] == null) {
      return Response(401, body: "access token is missing or invalid");
    } else {
      return null;
    }
  });
}
