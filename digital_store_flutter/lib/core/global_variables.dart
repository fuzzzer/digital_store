import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:get_it/get_it.dart';

import '../data/models/tokens.dart';

GetIt getTokens = GetIt.instance;

void setup() {
  getTokens.registerSingleton<Tokens>(
    Tokens(accessToken: '', refreshToken: ''),
  );

  getTokens
      .registerSingleton<AuthenticationRepository>(AuthenticationRepository());
}
