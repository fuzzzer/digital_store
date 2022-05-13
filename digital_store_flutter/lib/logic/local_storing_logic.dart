import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void removeOldRefreshTokenFromHive() async {
  final userCredentialsBox = await Hive.openBox('userCredentialsBox');

  userCredentialsBox.clear();
}

void storeCredentials(String refreshToken) async {
  final userCredentialsBox = await Hive.openBox('userCredentialsBox');

  userCredentialsBox.clear();

  userCredentialsBox.put('refreshToken', refreshToken);
}

Future<String?> readSavedRefreshTokenFromHive() async {
  final directory = await path_provider.getApplicationDocumentsDirectory();

  await Hive.initFlutter(directory.path);

  final userCredentialsBox =
      await Hive.openBox('userCredentialsBox', path: directory.path);

  final lastSeasonRefreshToken =
      userCredentialsBox.get('refreshToken') as String?;

  return lastSeasonRefreshToken;
}
