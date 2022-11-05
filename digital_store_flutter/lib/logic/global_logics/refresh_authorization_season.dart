import '../../core/global_variables.dart';
import '../../data/models/tokens.dart';
import '../../data/repositories/authentication_repository.dart';

Future<void> refreshSeason(
    final AuthenticationRepository authenticationRepository) async {
  final String refreshToken = serviceLocator
      .get<Tokens>()
      .refreshToken; // if cart is used then user is logged in and tokens are initialized

  Map<String, dynamic> newTokens =
      await authenticationRepository.postRefresh(refreshToken);

  serviceLocator.get<Tokens>().accessToken = newTokens['accessToken'];
  serviceLocator.get<Tokens>().refreshToken = newTokens['refreshToken'];
}

void sessionExpired() {}
