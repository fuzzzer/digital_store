import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:sqlite3/sqlite3.dart';
import 'database_interactions/global_queries.dart';

Response? checkIfUserIsAdmin(final Request request, final Database database) {
  if (request.context['authorizationDetails'] == null) {
    return Response(401, body: "access token is missing or invalid");
  }
  final authorizationDetails = request.context['authorizationDetails'] as JWT;

  if (authorizationDetails.subject == null) {
    return Response(401, body: "access token is missing or invalid");
  }

  final int isAdmin = int.parse(returnUniqueValueFromTheTable(
      database: database,
      table: 'user',
      inputValue: authorizationDetails.subject!,
      returnValue: 'is_admin',
      searchingColumn: 'id'));

  if (isAdmin != 1) {
    return Response(401, body: "access token is missing or invalid");
  }

  return null;
}
