import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../core/config.dart';
import '../../logic/database_interactions/global_queries.dart';
import '../../logic/database_interactions/queries_for_each_route/authentication_queries.dart';
import '../../data/models/user.dart';
import '../../logic/utilities/generators.dart';
import '../../logic/utilities/verifiers.dart';

class AuthenticationRoute {
  final Database database;
  final String secretKey;

  AuthenticationRoute(
      {required final this.database, required final this.secretKey});

  Router get router {
    final router = Router();

    Future<Response> _refreshHandler(final Request request) async {
      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      final refreshToken = decodedJson['refreshToken'];

      final JWT? maybeJWT = verifyJwt(refreshToken, secretKey);

      if (maybeJWT == null) {
        return Response(400, body: "not authorized for this action");
      }

      final newAccessToken = generateJwt(
        subject: maybeJWT.subject!,
        issuer: 'http://${Env.ipAdress}',
        secretKey: secretKey,
      );

      final newRefreshToken = generateJwt(
        subject: maybeJWT.subject!,
        issuer: 'http://${Env.ipAdress}',
        secretKey: secretKey,
        duration: Duration(seconds: 1000),
      );

      return Response(200,
          body: json.encode(
              {"accessToken": newAccessToken, "refreshToken": newRefreshToken}),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _signUpHandler(final Request request) async {
      final rawJson = await request.readAsString();
      final newUser = User.fromJson(jsonDecode(rawJson));

      if (!checkNewUserName(newUser)) {
        return Response(403, body: "User Name you entered is not supported");
      }

      if (!checkNewPassword(newUser)) {
        return Response(403, body: "Minimum password length is 8 letters");
      }

      if (isUniqueValueInTable(
          database: database,
          table: "user",
          value: newUser.email,
          searchingColumn: "email")) {
        return Response(409, body: "Email you entered already exists");
      }

      if (isUniqueValueInTable(
          database: database,
          table: "user",
          value: newUser.username,
          searchingColumn: "username")) {
        return Response(409, body: "User Name you entered already exists");
      }

      signUpNewUser(database, newUser);

      return Response(200, body: 'User is signed up');
    }

    Future<Response> _signInHandler(final Request request) async {
      final rawJson = await request.readAsString();
      final userCredentials = jsonDecode(rawJson);

      final idExists = isUniqueValueInTable(
          database: database,
          table: "user",
          value: userCredentials["username"],
          searchingColumn: "username");

      final passwordIsCorrect = checkPasswordValidity(
          database: database,
          username: userCredentials["username"],
          password: userCredentials["password"]);

      if (!idExists || !passwordIsCorrect) {
        return Response(404, body: 'Invalid username/password supplied');
      }

      String userId = returnUniqueValueFromTheTable(
          database: database,
          table: "user",
          inputValue: userCredentials["username"],
          returnValue: "id",
          searchingColumn: "username");

      final accessToken = generateJwt(
        subject: userId,
        issuer: 'http://${Env.ipAdress}',
        secretKey: secretKey,
      );

      final refreshToken = generateJwt(
        subject: userId,
        issuer: 'http://${Env.ipAdress}',
        secretKey: secretKey,
        duration: Duration(seconds: 1000),
      );

      return Response(200,
          body: json.encode(
              {"accessToken": accessToken, "refreshToken": refreshToken}),
          headers: {'Content-Type': 'application/json'});
    }

    Response _signOutHandler(final Request request) {
      if (request.context['authorizationDetails'] == null) {
        return Response(403, body: 'not authorised to log out');
      }
      return Response(200, body: 'logged out successfully');
    }

    router.post('/refresh', _refreshHandler);
    router.post('/sign-up', _signUpHandler);
    router.post('/sign-in', _signInHandler);
    router.get('/sign-out', _signOutHandler);

    return router;
  }
}
