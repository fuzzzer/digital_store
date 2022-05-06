import 'package:sqlite3/sqlite3.dart';

//this method return true is there is
bool isUniqueValueInTable(
    {required final Database database,
    required final String table,
    required final String value,
    required final String searchingColumn}) {
  final bool check = database.select(
      ''' SELECT * FROM "$table" WHERE "$searchingColumn" LIKE "$value";''').isNotEmpty;

  if (check) {
    return true;
  } else {
    return false;
  }
}

String returnUniqueValueFromTheTable(
    {required final Database database,
    required final String table,
    required final String inputValue,
    String returnValue = "id",
    required final String searchingColumn}) {
  String result = '';
  try {
    final selectedTable = database.select(
        ''' SELECT * FROM $table WHERE $searchingColumn LIKE "$inputValue"''');

    for (final row in selectedTable) {
      if (row[returnValue] is! String) {
        result = row[returnValue].toString();
      } else {
        result = row[returnValue];
      }
    }

    return result;
  } catch (err) {
    throw Exception("not found");
  }
}
