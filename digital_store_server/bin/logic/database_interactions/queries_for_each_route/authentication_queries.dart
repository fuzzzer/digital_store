import 'package:sqlite3/sqlite3.dart';

import '../../../data/models/user.dart';
import '../../utilities/generators.dart';
import '../../utilities/hashing.dart';

bool checkNewUserName(final User newUser) =>
    newUser.userName != '' ? true : false;

bool checkNewPassword(final User newUser) =>
    newUser.password.length > 8 ? true : false;

void signUpNewUser(final Database database, final User newUser) {
  final String id = generateNewID();

  final String cartId = generateNewID();

  final salt = generateSalt();
  final hashedPassword = hashPassword(newUser.password, salt);

  database.execute('''
              INSERT INTO user (id,
                username,
                password,
                salt,
                balance,
                is_admin,
                first_name,
                last_name,
                email,
                birth_date,
                phone_number,
                adress,
                sex ,
                created_at,
                modified_at,
                cart_id) 
              VALUES ("$id",
                "${newUser.userName}",
                "$hashedPassword",
                "$salt",
                ${newUser.balance},
                0,
                "${newUser.firstName}",
                "${newUser.lastName}",
                "${newUser.email}",
                "${newUser.birthDate}",
                "${newUser.phoneNumber}",
                "${newUser.adress}",
                "${newUser.sex}",
                date('now'),
                date('now'),
                "$cartId"
              )
          ''');

  database.execute(
      '''INSERT INTO cart (id, modified_at) VALUES ("$cartId", date('now'))''');
}

bool checkPasswordValidity(
    {required final Database database,
    required final String username,
    required final String password}) {
  String? realHashedPassword;
  final ResultSet selectedRowForHashedPassword = database
      .select(''' SELECT password FROM user WHERE username LIKE "$username"''');

  for (final row in selectedRowForHashedPassword) {
    // selectedRowForHashedPassword is iterable with only one value because username is unique
    realHashedPassword = row['password'];
  }

  String? salt;
  ResultSet selectedRowForSalt = database
      .select(''' SELECT salt FROM user WHERE username LIKE "$username"''');

  for (final row in selectedRowForSalt) {
    // selectedRowForSalt is iterable with only one value because username is unique
    salt = row['salt'];
  }

  if (salt != null) {
    if (hashPassword(password, salt) == realHashedPassword) {
      return true;
    }
  }

  return false;
}
