import 'package:sqlite3/sqlite3.dart';

import '../../../data/models/custom_exceptions.dart';
import '../../utilities/generators.dart';
import '../global_queries.dart';

List<Map<String, dynamic>> getAllProducts(final Database database) {
  final Map<String, Map<String, dynamic>> result = {};

  final selectedTable = database.select('''
      SELECT p.id as product_id,
       p.title as title,
       p.description as description,
       p.quantity as quantity,
       p.image as image,
       p.size as size,
       p.rating as rating,
       p.color as color,
       p.price as price,
       p.created_at as created_at,
       p.modified_at as modified_at,
       c.id as category_id
       FROM product as p
       JOIN product_category pc
       ON pc.product_id = p.id
       JOIN category c
       ON pc.category_id = c.id;
      ''');

  for (final row in selectedTable) {
    final String currentId = row['product_id'];
    if (result.containsKey(currentId)) {
      result[currentId]!['categories'].add(row['category_id']);
    } else {
      result[currentId] = {
        'id': row['product_id'],
        'title': row['title'],
        'description': row['description'],
        'quantity': row['quantity'],
        'image': row['image'],
        'size': row['size'],
        'rating': row['rating'],
        'categories': <String>[row['category_id']],
        'color': row['color'],
        'price': row['price'],
        'createdAt': row['created_at'],
        'modifiedAt': row['modified_at']
      };
    }
  }

  return result.values.toList();
}

void createNewProduct(
    final Database database, final Map<String, dynamic> info) {
  if (info.values.any((element) => element == null)) {
    throw InvalidInputException("passed value is null");
  }

  for (final categoryId in info['categories']) {
    if (!isUniqueValueInTable(
        database: database,
        table: "category",
        value: categoryId,
        searchingColumn: "id")) {
      throw InvalidInputException("not existent category was passed");
    }
  }

  final productId = generateNewID();

  database.execute('''
    INSERT INTO product (id, title, description, quantity, image, size, rating, color, price ,created_at, modified_at) 
    VALUES ("$productId", "${info['title']}", "${info['description']}", ${info['quantity']}, "${info['image']}", "${info['size']}", ${info['rating']}, "${info['color']}", "${info['price']}", date('now'), date('now'))
    ''');

  for (final categoryId in info['categories']) {
    final productCategoryId = generateNewID();

    database.execute('''
       INSERT INTO product_category (id, product_id, category_id) 
       VALUES ("$productCategoryId", "$productId", "$categoryId")
       ''');
  }
}

Map<String, dynamic> getProduct(
    final Database database, final String productId) {
  Map<String, dynamic> result = {};

  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');

  if (!productExists) {
    throw NotFoundException('product not found');
  }

  final selectedTable = database.select('''
       SELECT p.id as product_id,
        p.title as title,
        p.description as description,
        p.quantity as quantity,
        p.image as image,
        p.size as size,
        p.rating as rating,
        p.color as color,
        p.price as price,
        p.created_at as created_at,
        p.modified_at as modified_at,
        c.id as category_id
       FROM product as p
       JOIN product_category pc
       ON pc.product_id = p.id
       JOIN category c
       ON pc.category_id = c.id
       WHERE p.id LIKE "$productId"
      ''');

  int countCategories = 0;

  for (final row in selectedTable) {
    if (countCategories != 0) {
      result['categories'].add(row['category_id']);
    } else {
      result = {
        'id': row['product_id'],
        'title': row['title'],
        'description': row['description'],
        'quantity': row['quantity'],
        'image': row['image'],
        'size': row['size'],
        'rating': row['rating'],
        'categories': <String>[row['category_id']],
        'color': row['color'],
        'price': row['price'],
        'createdAt': row['created_at'],
        'modifiedAt': row['modified_at']
      };
      countCategories++;
    }
  }

  return result;
}

void updateProduct(final Database database, final String productId,
    final Map<String, dynamic> info) {
  if (info.values.any((element) => element == null)) {
    throw InvalidInputException("passed value is null");
  }

  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');

  if (!productExists) {
    throw NotFoundException('product not found');
  }

  for (final categoryId in info['categories']) {
    if (!isUniqueValueInTable(
        database: database,
        table: "category",
        value: categoryId,
        searchingColumn: "id")) {
      throw InvalidInputException("not existent category was passed");
    }
  }

  database.execute('''
    UPDATE product
      SET title = "${info['title']}",
      description = "${info['description']}",
      quantity = "${info['quantity']}",
      image = "${info['image']}",
      size = "${info['size']}",
      rating = "${info['rating']}",
      color = "${info['color']}",
      price = "${info['price']}",
      modified_at = date('now')
      WHERE id LIKE "$productId"
    ''');

  database.execute('''
     DELETE FROM product_category
     WHERE product_id LIKE "$productId"
     ''');

  for (final categoryId in info['categories']) {
    final productCategoryId = generateNewID();

    database.execute('''
       INSERT INTO product_category (id, product_id, category_id) 
       VALUES ("$productCategoryId", "$productId", "$categoryId")
       ''');
  }
}

void deleteProduct(final Database database, final String productId) {
  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');

  if (!productExists) {
    throw NotFoundException('product not found');
  }

  database.execute('''
    DELETE FROM product
    WHERE id LIKE "$productId";
    ''');
}

void purchaseProduct({
  required final Database database,
  required final int quantity,
  required final String productId,
  required final String userId,
}) {
  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');

  if (!productExists) {
    throw NotFoundException('product not found');
  }

  int availableQuantity = int.parse(returnUniqueValueFromTheTable(
      database: database,
      table: 'product',
      inputValue: productId,
      returnValue: 'quantity',
      searchingColumn: 'id'));

  if (quantity > availableQuantity) {
    throw ProductNotAvailableException("too much quantity selected");
  }

  double balance = double.parse(returnUniqueValueFromTheTable(
      database: database,
      table: 'user',
      inputValue: userId,
      returnValue: 'balance',
      searchingColumn: 'id'));

  final double totalPrice = double.parse(returnUniqueValueFromTheTable(
          database: database,
          table: 'product',
          inputValue: productId,
          returnValue: 'price',
          searchingColumn: 'id')) *
      quantity;

  if (totalPrice > balance) {
    throw NotEnoughMoneyException("not enough money on balance");
  }

  balance -= balance - totalPrice;
  availableQuantity -= availableQuantity - quantity;

  database.execute('''
   UPDATE user
   SET balance = $balance,
   modified_at = date('now')
   WHERE id LIKE "$userId"
  ''');

  database.execute('''
   UPDATE product
   SET quantity = $availableQuantity,
   modified_at = date('now')
   
   WHERE id LIKE "$productId"
  ''');

  final orderId = generateNewID();

  database.execute('''
   INSERT INTO "order" (id, product_id, user_id, quantity, created_at, modified_at) 
   VALUES ("$orderId", "$productId", "$userId", "$quantity", date('now'), date('now'));
   ''');
}

void reviewProduct({
  required final Database database,
  required final Map<String, dynamic> info,
  required final String productId,
  required final String userId,
}) {
  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');

  if (!productExists) {
    throw NotFoundException('product not found');
  }

  final bool userReviewedProduct = isUniqueValueInTable(
      database: database,
      table: 'product_review',
      value: userId,
      searchingColumn: 'user_id');

  if (userReviewedProduct) {
    throw ExistentIdentifierException('User has already rated product');
  }

  final productReviewId = generateNewID();

  database.execute('''
   INSERT INTO product_review (id, user_id, product_id, rating, review, created_at, modified_at)
   VALUES ("$productReviewId", "$userId", "$productId", ${info['rating']}, "${info['review']}", date('now'), date('now'));
''');
}

List<Map<String, dynamic>> getAllProductReviews({
  required final Database database,
  required final String productId,
}) {
  final List<Map<String, dynamic>> result = [];

  final bool productExists = isUniqueValueInTable(
      database: database,
      table: 'product',
      value: productId,
      searchingColumn: 'id');
  if (!productExists) {
    throw NotFoundException('product not found');
  }

  final selectedTable = database.select('''
    SELECT * 
    FROM product_review
    WHERE product_id LIKE "$productId";
   ''');

  for (final row in selectedTable) {
    result.add({
      "userId": row['user_id'],
      "productId": row['product_id'],
      "rating": row['rating'],
      "review": row['review'],
      "createdAt": row['created_at'],
      "modified_at": row['modified_at']
    });
  }

  return result;
}
