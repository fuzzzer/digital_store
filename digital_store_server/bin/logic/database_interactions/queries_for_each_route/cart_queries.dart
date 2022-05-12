import 'package:sqlite3/sqlite3.dart';

import '../../../data/models/custom_exceptions.dart';
import '../../utilities/generators.dart';
import '../global_queries.dart';

Map<String, List> getAllCartItemFromDatabase(
    final Database database, final String userId) {
  final Map<String, List> result = {"products": []};
  final ResultSet resultSet = database.select(
      'SELECT product_id as id, quantity FROM cart_item WHERE cart_id LIKE (SELECT cart_id FROM user WHERE id LIKE  "$userId")');
  resultSet.forEach((element) => result['products']!.add(element));
  return result;
}

void addToCart(final Database database, final Map<String, dynamic> product,
    final String userId) {
  final bool check = database.select('''
  SELECT product_id 
  FROM cart_item
  WHERE cart_id LIKE (SELECT cart_id FROM user WHERE id LIKE  "$userId")
  AND product_id = "${product['id']}"
   ''').isNotEmpty;

  if (check) {
    throw ExistentIdentifierException('product already is in the users cart');
  }

  final String cartItemId = generateNewID();

  database.execute('''
  INSERT INTO cart_item (id, cart_id, product_id, quantity, created_at, modified_at)
  VALUES ("$cartItemId", (SELECT cart_id FROM user WHERE id LIKE "$userId"), "${product['id']}", ${product['quantity']}, date('now'), date('now'))''');
}

void updateCartItem(
    {required final Database database,
    required final String productId,
    required final int quantity,
    required final String userId}) {
  final String cartId = returnUniqueValueFromTheTable(
      database: database,
      table: "user",
      inputValue: userId,
      returnValue: "cart_id",
      searchingColumn: "id");

  final bool check = database.select(''' 
   SELECT *
   FROM cart_item
   WHERE product_id LIKE "$productId"
   AND cart_id LIKE "$cartId"
   ''').isNotEmpty;

  if (check) {
    database.execute('''UPDATE cart_item
     SET quantity = $quantity,
    modified_at = date('now')
     WHERE product_id LIKE "$productId"
     AND cart_id LIKE "$cartId" ; ''');
  } else {
    throw NotFoundException('cart item not found');
  }
}

void removeCartItem(
    final Database database, final String productId, final String userId) {
  final String cartId = returnUniqueValueFromTheTable(
      database: database,
      table: "user",
      inputValue: userId,
      returnValue: "cart_id",
      searchingColumn: "id");

  final bool check = database.select(''' 
   SELECT * 
   FROM cart_item
   WHERE product_id LIKE "$productId"
   AND cart_id LIKE "$cartId"
   ''').isNotEmpty;

  if (check) {
    database.execute(''' DELETE FROM cart_item
     WHERE product_id LIKE "$productId"
     AND cart_id LIKE "$cartId" ; ''');
  } else {
    throw NotFoundException('cart item not found');
  }
}

void cartCheckout(final Database database, final String userId) {
  final String cartId = returnUniqueValueFromTheTable(
      database: database,
      table: "user",
      inputValue: userId,
      returnValue: "cart_id",
      searchingColumn: "id");

  double totalCartPrice = 0;

  final selectedTable = database.select(''' 
   SELECT IFNULL(SUM(cart_item.quantity *
   product.price), 0) as total_price
   FROM cart_item
   JOIN product
   ON product.id = cart_item.product_id
   WHERE cart_id LIKE "$cartId"; 
   ''');

  for (final row in selectedTable) {
    totalCartPrice += row['total_price'];
  }

  double balance = double.parse(returnUniqueValueFromTheTable(
      database: database,
      table: "user",
      inputValue: userId,
      returnValue: 'balance',
      searchingColumn: "id"));

  print("total card balance: $totalCartPrice");
  print("balance: $balance");

  if (totalCartPrice > balance) {
    throw NotEnoughMoneyException("not enough money on balance");
  }

  final bool cartItemQuantityOverFlowCheck = database.select('''
   SELECT cart_item.id
   FROM cart_item
   JOIN product
   ON product.id = cart_item.product_id
   WHERE cart_item.cart_id LIKE "$cartId"
   AND product.quantity < cart_item.quantity;
   ''').isNotEmpty;

  if (cartItemQuantityOverFlowCheck) {
    throw ProductNotAvailableException("too much quantity selected");
  }

  balance -= totalCartPrice;

  database.execute('''
   UPDATE product
   SET quantity = quantity - (SELECT quantity FROM cart_item WHERE cart_id LIKE "$cartId" AND product_id = product.id),
   modified_at = date('now')
   WHERE id LIKE (SELECT product_id FROM cart_item WHERE cart_id LIKE "$cartId" AND product_id = product.id);
   ''');

  database.execute('''
   UPDATE user
   SET balance = "$balance",
   modified_at = date('now')
   WHERE id LIKE "$userId"
   ''');

  final tableToCreateOrder = database.select(
      '''SELECT product_id, quantity FROM cart_item WHERE cart_id LIKE "$cartId" ''');

  for (final row in tableToCreateOrder) {
    final orderId = generateNewID();

    database.execute('''
     INSERT INTO "order" (id, product_id, user_id, quantity, created_at, modified_at) 
     VALUES ("$orderId", "${row['product_id']}", "$userId", ${row['quantity']}, date('now'), date('now'));
     ''');
  }

  database.execute(''' 
   DELETE FROM cart_item
   WHERE cart_id LIKE "$cartId"; 
   ''');
}

void clearCart(final Database database, final String userId) {
  final String cartId = returnUniqueValueFromTheTable(
      database: database,
      table: "user",
      inputValue: userId,
      returnValue: "cart_id",
      searchingColumn: "id");

  database.execute(''' 
   DELETE FROM cart_item
   WHERE cart_id LIKE "$cartId"; 
   ''');
}
