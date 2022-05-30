import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../data/models/tokens.dart';

GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<Tokens>(
    Tokens(accessToken: '', refreshToken: ''),
  );

  getIt.registerSingleton<Map>({'userShouldBeRemembered': false});

  getIt.registerSingleton<Client>(
    Client(),
  );

  getIt.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
}
