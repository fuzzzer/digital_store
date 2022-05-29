import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

import '../data/models/tokens.dart';

GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<Tokens>(
    Tokens(accessToken: '', refreshToken: ''),
  );

  getIt.registerSingleton<Map>({'userShouldBeRemembered': false});

  getIt.registerSingleton<RetryClient>(
    RetryClient(
      Client(),
      // retries: 1,
      // when: (response) => response.statusCode == 401,
      // onRetry: (baseRequest, baseResponse, index) async {
      //   await refreshSeason((authenticationRepository));
      //   baseRequest.headers['authorization'] =
      //       'Bearer ${getIt.get<Tokens>().accessToken}';
      // },
    ),
  );

  getIt.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
}
