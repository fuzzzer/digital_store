import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:get_it/get_it.dart';

import '../data/models/tokens.dart';

GetIt serviceLocator = GetIt.instance;

void setup() {
  serviceLocator.registerSingleton<Tokens>(
    Tokens(accessToken: '', refreshToken: ''),
  );

  serviceLocator
      .registerSingleton<AuthenticationRepository>(AuthenticationRepository());
}
