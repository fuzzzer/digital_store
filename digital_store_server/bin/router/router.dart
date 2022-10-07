import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

import 'middlewares/verify_authorization.dart';
import 'routes/authentication_Route.dart';
import 'routes/cart_route.dart';
import 'routes/categories_route.dart';
import 'routes/product_route.dart';
import 'routes/user_route.dart';

class DigitalStoreRouter {
  final Database database;
  final String secretKey;
  DigitalStoreRouter(
      {required this.database, required this.secretKey});

  Handler get handler {
    final Router router = Router()
      // ..mount('/open_api/', )
      ..mount('/authentication/',
          AuthenticationRoute(database: database, secretKey: secretKey).router)
      ..mount('/cart/', CartRoute(database: database).router)
      ..mount('/categories/', CategoriesRoute(database: database).router)
      ..mount('/products/', ProductRoute(database: database).router)
      ..mount('/user/', UserRoute(database: database).router);

    final Handler handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(handleAuthorization(secretKey))
        .addHandler(router);

    return handler;
  }
}
