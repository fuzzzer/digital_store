import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/models/custom_exceptions.dart';
import '../../logic/check_authentication.dart';
import '../../logic/database_interactions/queries_for_each_route/product_queries.dart';

class ProductRoute {
  final Database database;
  ProductRoute({required final this.database});

  Router get router {
    final router = Router();

    Future<Response> _getAllProductsHandler(final Request request) async {
      List<Map<String, dynamic>> response = getAllProducts(database);

      return Response.ok(json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _getProductsByCategoryHandler(
        final Request request, String categoryId) async {
      late List<Map<String, dynamic>> response =
          getProductsFilteredByCategories(database, [categoryId]);

      return Response.ok(json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _getProductsBySearchHandler(
        final Request request, String toSearch) async {
      print(toSearch);
      print(toSearch == '');

      late List<Map<String, dynamic>> response =
          getProductsFilteredBySearch(database, toSearch);

      return Response.ok(json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _newProductHandler(final Request request) async {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        createNewProduct(database, decodedJson);
      } on InvalidInputException catch (ex) {
        return Response(405, body: ex.reason);
      }

      return Response(200, body: 'new product added');
    }

    Response _getProductHandler(final Request request, final String id) {
      try {
        final response = getProduct(database, id);
        return Response(200,
            body: json.encode(response),
            headers: {'Content-Type': 'application/json'});
      } on NotFoundException {
        return Response(404, body: "product not found");
      }
    }

    Future<Response> _updateProductHandler(
        final Request request, final String id) async {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        updateProduct(database, id, decodedJson);
      } on NotFoundException {
        return Response(404, body: "product not found");
      } on InvalidInputException catch (ex) {
        return Response(400, body: ex.reason);
      }

      return Response(200, body: 'product updated');
    }

    Response _deleteProductHandler(final Request request, final String id) {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      try {
        deleteProduct(database, id);
      } on NotFoundException {
        return Response(404, body: "product not found");
      }

      return Response(200, body: 'product deleted');
    }

    Future<Response> _productPurchaseHandler(
        final Request request, final String id) async {
      if (request.context['authorizationDetails'] == null) {
        return Response(401, body: "access token is missing or invalid");
      }

      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        purchaseProduct(
            database: database,
            quantity: decodedJson['quantity'],
            productId: id,
            userId: authorizationDetails.subject!);
      } on NotFoundException {
        return Response(404, body: "product not found");
      } on NotEnoughMoneyException {
        return Response(403, body: "Not enough money! fill in the balance");
      } on ProductNotAvailableException {
        return Response(403,
            body: "Unsuccessful payment! Check avalable product quantities");
      }

      return Response(200, body: 'product successfuly purchased');
    }

    Future<Response> _productReviewHandler(
        final Request request, final String id) async {
      if (request.context['authorizationDetails'] == null) {
        return Response(401, body: "access token is missing or invalid");
      }

      final authorizationDetails =
          request.context['authorizationDetails'] as JWT;

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        reviewProduct(
            database: database,
            info: decodedJson,
            productId: id,
            userId: authorizationDetails.subject!);
      } on NotFoundException {
        return Response(404, body: "product not found");
      } on ExistentIdentifierException {
        return Response(403, body: "user already reviewed product");
      }

      return Response(200, body: 'product review uploaded');
    }

    Response _getAllProductReviewsHandler(
        final Request request, final String id) {
      try {
        final List<Map<String, dynamic>> productReviews = getAllProductReviews(
          database: database,
          productId: id,
        );

        return Response(200,
            body: json.encode(productReviews),
            headers: {'Content-Type': 'application/json'});
      } on NotFoundException {
        return Response(404, body: "product not found");
      }
    }

    router.get('/', _getAllProductsHandler);
    router.post('/', _newProductHandler);
    router.get('/by-category/<categoryId>', _getProductsByCategoryHandler);
    router.get('/by-search/<toSearch>', _getProductsBySearchHandler);
    router.get('/<id>', _getProductHandler);
    router.patch('/<id>', _updateProductHandler);
    router.delete('/<id>', _deleteProductHandler);
    router.put('/purchase/<id>', _productPurchaseHandler);
    router.put('/review/<id>', _productReviewHandler);
    router.get('/review/<id>', _getAllProductReviewsHandler);

    return router;
  }
}
