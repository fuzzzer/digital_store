import 'package:sqlite3/sqlite3.dart';

import '../../../data/models/custom_exceptions.dart';
import '../../utilities/generators.dart';
import '../global_queries.dart';

List<Map<String, dynamic>> getAllCategories(final Database database) {
  final List<Map<String, dynamic>> result = [];

  final selectedTable =
      database.select('SELECT id, title, description FROM category');

  for (final row in selectedTable) {
    final tempMap = {
      'id': row['id'],
      'title': row['title'],
      'description': row['description']
    };
    result.add(tempMap);
  }

  return result;
}

void createNewCategory(
    final Database database, final Map<String, dynamic> info) {
  if (info['title'] == null || info['description'] == null) {
    throw InvalidInputException;
  }

  final bool categoryExists = isUniqueValueInTable(
      database: database,
      table: 'category',
      value: info['title'],
      searchingColumn: 'title');

  if (categoryExists) {
    throw ExistentIdentifierException;
  }

  final String categoryId = generateNewID();

  database.execute('''
    INSERT INTO category (id, title, description, created_at, modified_at) 
    VALUES ("$categoryId", "${info['title']}", "${info['description']}", date('now'), date('now'))
    ''');
}

void updateCategory(final Database database, final String categoryId,
    final Map<String, dynamic> info) {
  if (info['title'] == null || info['description'] == null) {
    throw InvalidInputException("null passes");
  }

  final bool titleIsTaken = database.select('''
     SELECT * 
     FROM category 
     WHERE title LIKE "${info['title']}" 
     AND id NOT LIKE "$categoryId";''').isNotEmpty;

  if (titleIsTaken) {
    throw ExistentIdentifierException("title is already taken");
  }

  final bool categoryExists = isUniqueValueInTable(
      database: database,
      table: 'category',
      value: categoryId,
      searchingColumn: 'id');

  if (categoryExists) {
    database.execute('''
     UPDATE category
     SET title = "${info['title']}",
     description = "${info['description']}",
     modified_at = date('now')
     WHERE id LIKE "$categoryId";
     ''');
  } else {
    throw NotFoundException('category not found');
  }
}

void deleteCategory(final Database database, final String categoryId) {
  final bool categoryExists = isUniqueValueInTable(
      database: database,
      table: 'category',
      value: categoryId,
      searchingColumn: 'id');

  if (categoryExists) {
    database.execute('''
     DELETE FROM category
     WHERE id LIKE "$categoryId";
     ''');
  } else {
    throw NotFoundException('cart item not found');
  }
}
