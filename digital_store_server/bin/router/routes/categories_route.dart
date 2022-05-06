import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../data/models/custom_exceptions.dart';
import '../../logic/check_authentication.dart';
import '../../logic/database_interactions/queries_for_each_route/categories_queries.dart';

class CategoriesRoute {
  final Database database;
  CategoriesRoute({required final this.database});
  Router get router {
    final router = Router();

    Response _getAllCategoriesHandler(final Request request) {
      final response = getAllCategories(database);

      return Response(200,
          body: json.encode(response),
          headers: {'Content-Type': 'application/json'});
    }

    Future<Response> _newCategoryHandler(final Request request) async {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        createNewCategory(database, decodedJson);
      } on InvalidInputException {
        return Response(405, body: "Invalid input ");
      } on ExistentIdentifierException {
        return Response(403, body: "category already exists");
      }

      return Response(200, body: 'new category');
    }

    Future<Response> _updateCategoryHandler(
        final Request request, final String id) async {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      final rawJson = await request.readAsString();
      final decodedJson = json.decode(rawJson);

      try {
        updateCategory(database, id, decodedJson);
      } on InvalidInputException {
        return Response(400, body: "Invalid input");
      } on NotFoundException {
        return Response(404, body: "category not found");
      } on ExistentIdentifierException {
        return Response(403, body: "category with that title already exists");
      }

      return Response(200, body: 'category successfuly updated');
    }

    Future<Response> _deleteCategoryHandler(
        final Request request, final String id) async {
      Response? maybeNotValid = checkIfUserIsAdmin(request, database);

      if (maybeNotValid != null) {
        return maybeNotValid;
      }

      try {
        deleteCategory(database, id);
      } on NotFoundException {
        return Response(404, body: "category not found");
      }

      return Response(200, body: 'category successfuly deleted');
    }

    router.get('/', _getAllCategoriesHandler);
    router.post('/', _newCategoryHandler);
    router.patch('/<id>', _updateCategoryHandler);
    router.delete('/<id>', _deleteCategoryHandler);

    return router;
  }
}
