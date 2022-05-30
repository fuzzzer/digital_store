import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';

void updateTokens(Map<String, dynamic> tokens) {
  if (getIt.isRegistered<Tokens>()) {
    getIt.unregister<Tokens>();
  }

  getIt.registerSingleton<Tokens>(
    Tokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken']),
  );
}
