import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/models/custom_exceptions.dart';
import '../../logic/database_interactions/queries_for_each_route/user_queries.dart';
import '../middlewares/verify_authorization.dart';

class UserRoute {
  final Database database;
  UserRoute({required this.database});

  Handler get router {
    final router = Router();

    final handler =
        Pipeline().addMiddleware(checkAuthorization()).addHandler(router);

    Response _deleteUserHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      try {
        deleteUser(database, authorizationDetails.subject!);
      } on NotFoundException {
        return Response(404, body: "user not found");
      }

      return Response(200, body: 'user deleted');
    }

    Response _getAllUserOrdersHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      List<Map<String, dynamic>> response =
          getAllUserOrders(database, authorizationDetails.subject!);

      return Response(200,
          body: json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Response _getUserOrderHandler(final Request request, final String id) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      Map<String, dynamic> response =
          getUserOrder(database, authorizationDetails.subject!, id);

      return Response(200,
          body: json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Response _getUserBalanceHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      Map<String, dynamic> response =
          getUserBalance(database, authorizationDetails.subject!);

      return Response(200,
          body: json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _updateUserBalanceHandler(final Request request) async {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      updateUserBalance(
          database, authorizationDetails.subject!, decodedJson['amount']);

      return Response(200, body: 'updated user balance');
    }

    Response _getUserProfileHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      Map<String, dynamic> response =
          getUserProfile(database, authorizationDetails.subject!);

      return Response(200,
          body: json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _updateUserProfileHandler(final Request request) async {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        updateUserProfile(database, authorizationDetails.subject!, decodedJson);
      } on NotFoundException {
        Response(404, body: "user not found");
      } on ExistentIdentifierException {
        Response(403, body: "email you entered already exists");
      }

      return Response(200, body: 'updated user profile');
    }

    router.delete('/', _deleteUserHandler);
    router.get('/orders', _getAllUserOrdersHandler);
    router.get('/orders/<id>', _getUserOrderHandler);
    router.get('/balance', _getUserBalanceHandler);
    router.patch('/balance', _updateUserBalanceHandler);
    router.get('/profile', _getUserProfileHandler);
    router.patch('/profile', _updateUserProfileHandler);

    return handler;
  }
}
