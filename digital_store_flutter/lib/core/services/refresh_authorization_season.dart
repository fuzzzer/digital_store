import 'package:digital_store_flutter/core/services/update_singletons.dart';
import 'package:digital_store_flutter/data/models/custom_exceptions.dart';
import 'package:digital_store_flutter/logic/global_logics/local_storing_logic.dart';

import '../global_variables.dart';
import '../../data/models/tokens.dart';
import '../../data/repositories/authentication_repository.dart';

Future<void> refreshSeason() async {
  final authenticationRepository = getIt.get<AuthenticationRepository>();
  final String refreshToken = getIt.get<Tokens>().refreshToken;

  final Map<String, dynamic> tokens;

  try {
    tokens = await authenticationRepository.postRefresh(refreshToken);
  } on InvalidRefreshTokenException catch (ex) {
    throw InvalidRefreshTokenException(ex.reason);
  }

  updateTokens(tokens);

  if (getIt.get<Map>()['userShouldBeRemembered']) {
    storeCredentials(getIt.get<Tokens>().refreshToken);
  }
}

void sessionExpired() {
  //ToDo: remove refresh token from the database,
  // move refreshSeason to repositories and delete checks from the cubits,
  // emit error state on expired refresh token and move to home page and change state to user unauthenticated
}
