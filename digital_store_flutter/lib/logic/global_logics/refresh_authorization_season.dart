import '../../core/global_variables.dart';
import '../../data/models/tokens.dart';
import '../../data/repositories/authentication_repository.dart';

Future<void> refreshSeason(
    AuthenticationRepository authenticationRepository) async {
  String refreshToken = getTokens
      .get<Tokens>()
      .refreshToken; // if cart is used then user is logged in and tokens are initialized

  Map<String, dynamic> newTokens =
      await authenticationRepository.postRefresh(refreshToken);

  getTokens.get<Tokens>().accessToken = newTokens['accessToken'];
  getTokens.get<Tokens>().refreshToken = newTokens['refreshToken'];
}

void sessionExpired() {}
