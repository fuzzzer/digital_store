import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/models/custom_exceptions.dart';
import '../../logic/database_interactions/queries_for_each_route/cart_queries.dart';
import '../middlewares/verify_authorization.dart';

class CartRoute {
  final Database database;
  CartRoute({required final this.database});

  Handler get router {
    final router = Router();

    final handler =
        Pipeline().addMiddleware(checkAuthorization()).addHandler(router);

    Response _getAllCartItemsHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final Map<String, List<dynamic>> response;

      response =
          getAllCartItemFromDatabase(database, authorizationDetails.subject!);

      return Response.ok(json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _newCartItemHandler(final Request request) async {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        addToCart(database, decodedJson, authorizationDetails.subject!);
      } on ExistentIdentifierException {
        return Response(403, body: "product is already in the users cart");
      } on InvalidInputException catch (ex) {
        return Response(405, body: ex.reason);
      }

      return Response(200, body: 'new cart item added');
    }

    Future<Response> _updateCartItemHandler(
        final Request request, final String id) async {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;
      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        updateCartItem(
            database: database,
            productId: id,
            quantity: decodedJson['quantity'],
            userId: authorizationDetails.subject!);
      } on NotFoundException {
        return Response(404, body: "Cart item not found");
      } on InvalidInputException catch (ex) {
        return Response(405, body: ex.reason);
      }

      return Response(200, body: "cart item successfuly updated");
    }

    Future<Response> _deleteCartItemHandler(
        final Request request, final String id) async {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      try {
        removeCartItem(database, id, authorizationDetails.subject!);
        return Response(200, body: 'cart item successfully removed');
      } on NotFoundException {
        return Response(404, body: 'cart item not found');
      }
    }

    Response _checkoutFromCartHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      try {
        cartCheckout(database, authorizationDetails.subject!);
      } on ProductNotAvailableException catch (ex) {
        print('Check avalable product quantities');
        return Response(403, body: ex.reason);
      } on NotEnoughMoneyException {
        print('Not exnough money');
        return Response(403, body: 'Not enough money! fill in the balance');
      }

      return Response(200, body: 'successful checkout');
    }

    Response _clearCartHandler(final Request request) {
      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      clearCart(database, authorizationDetails.subject!);

      return Response(200, body: 'cart is cleared');
    }

    router.get('/', _getAllCartItemsHandler);
    router.post('/', _newCartItemHandler);
    router.patch('/<id>', _updateCartItemHandler);
    router.delete('/<id>', _deleteCartItemHandler);
    router.post('/checkout', _checkoutFromCartHandler);
    router.delete('/clear/all', _clearCartHandler);

    return handler;
  }
}
