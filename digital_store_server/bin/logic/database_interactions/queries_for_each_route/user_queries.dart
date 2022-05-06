import 'package:sqlite3/sqlite3.dart';

import '../../../data/models/custom_exceptions.dart';
import '../global_queries.dart';

void deleteUser(Database database, String userId) {
  if (!isUniqueValueInTable(
      database: database,
      table: 'user',
      value: userId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }
  database.execute('''
   DELETE from user 
   WHERE id LIKE "$userId";
   ''');
}

List<Map<String, dynamic>> getAllUserOrders(
    final Database database, final String userId) {
  final List<Map<String, dynamic>> result = [];

  final selectedTable = database.select('''
   SELECT 
   "order".id as id ,
          "order".product_id as product_id,
          "order".quantity as quantity,
          product.price as price,
          "order".created_at as created_at
  FROM "order"
  JOIN product
  on "order".product_id = product.id
  WHERE user_id LIKE "$userId";
    ''');

  for (final row in selectedTable) {
    result.add({
      "id": row['product_id'],
      "quantity": row['quantity'],
      "price": row['price'],
      "totalPrice": row['quantity'] * row['price'],
      "createdAt": row['created_at']
    });
  }
  return result;
}

Map<String, dynamic> getUserOrder(
    final Database database, final String userId, final String orderId) {
  late final Map<String, dynamic> result;

  if (!isUniqueValueInTable(
      database: database,
      table: 'order',
      value: orderId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }

  final selectedTable = database.select('''
   SELECT "order".id as order_id ,
          "order".product_id as product_id,
          "order".quantity as quantity,
          product.price as price,
          "order".created_at as created_at
  FROM "order"
  JOIN product
  on "order".product_id = product.id
  WHERE user_id LIKE "$userId" 
  AND order_id LIKE "$orderId";
    ''');

  for (final row in selectedTable) {
    result = {
      "id": row['product_id'],
      "quantity": row['quantity'],
      "price": row['price'],
      "totalPrice": row['quantity'] * row['price'],
      "createdAt": row['created_at']
    };
  }

  return result;
}

Map<String, dynamic> getUserBalance(
    final Database database, final String userId) {
  late final Map<String, dynamic> result;

  if (!isUniqueValueInTable(
      database: database,
      table: 'user',
      value: userId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }

  final selectedTable = database.select('''
   SELECT balance,
   modified_at
   FROM user
   WHERE id LIKE "$userId";
   ''');

  for (final row in selectedTable) {
    result = {"balance": row['balance'], "modifiedAt": row['modified_at']};
  }

  return result;
}

void updateUserBalance(
    final Database database, final String userId, final int amount) {
      
  if (!isUniqueValueInTable(
      database: database,
      table: 'user',
      value: userId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }

  database.execute('''
   UPDATE user
   SET balance = $amount,
   modified_at = date('now')
   WHERE id LIKE "$userId";
''');
}

Map<String, dynamic> getUserProfile(
    final Database database, final String userId) {
  late final Map<String, dynamic> result;

  if (!isUniqueValueInTable(
      database: database,
      table: 'user',
      value: userId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }

  final selectedTable = database.select('''
   SELECT id, username, balance, first_name, last_name, email, birth_date, phone_number, adress, sex, created_at, modified_at
    FROM user
WHERE id LIKE "$userId";
   ''');

  for (final row in selectedTable) {
    result = {
      "id": row['id'],
      "username": row['username'],
      "balance": row['balance'],
      "firstName": row['first_name'],
      "lastName": row['last_name'],
      "email": row['email'],
      "birthDate": row['birth_date'],
      "phoneNumber": row['phone_number'],
      "adress": row['adress'],
      "sex": row['sex'],
      "createdAt": row['created_at'],
      "modifiedAt": row['modified_at']
    };
  }

  return result;
}

void updateUserProfile(final Database database, final String userId,
    final Map<String, dynamic> decodedJson) {
  if (!isUniqueValueInTable(
      database: database,
      table: 'user',
      value: userId,
      searchingColumn: 'id')) {
    throw NotFoundException("user not found");
  }

  if (isUniqueValueInTable(
      database: database,
      table: 'user',
      value: decodedJson['email'],
      searchingColumn: 'email')) {
    throw ExistentIdentifierException("email is not available");
  }

  database.execute('''
   UPDATE user
   SET first_name = "${decodedJson['firstName']}",
   last_name = "${decodedJson['lastName']}",
   email = "${decodedJson['email']}",
   birth_date = "${decodedJson['birthDate']}",
   phone_number = "${decodedJson['phone_number']}",
   sex = "${decodedJson['sex']}"
   WHERE id LIKE "$userId";
   ''');
}
