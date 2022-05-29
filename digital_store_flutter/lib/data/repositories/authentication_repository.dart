import 'dart:convert';

import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:http/retry.dart';
import '../../core/config.dart';
import '../../logic/global_logics/checkers.dart';
import '../models/custom_exceptions.dart';

class AuthenticationRepository {
  final client = getIt.get<RetryClient>();
  final String startingPath = 'http://$ipAdress:$port/authentication/';

  Future<Map<String, dynamic>> postRefresh(final String refreshToken) async {
    final response = await client.post(Uri.parse('${startingPath}refresh'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      if (checkTokens(decodedJson)) {
        final result = decodedJson as Map<String, dynamic>;
        return result;
      } else {
        throw const InvalidTokenRecievedException(
            'for safety measures login later, token was not sent from original server');
      }
    } else {
      throw InvalidRefreshTokenException(response.body);
    }
  }

  Future<bool> postsignUp(final Map<String, dynamic> newUser) async {
    final response = await client.post(Uri.parse('${startingPath}sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUser));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<Map<String, dynamic>> postSignIn(
      final Map<String, dynamic> userCredentials) async {
    final response = await client.post(Uri.parse('${startingPath}sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userCredentials));
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      if (checkTokens(decodedJson)) {
        final result = decodedJson as Map<String, dynamic>;
        getIt.get<Tokens>().refreshToken = result['refreshToken'];

        return result;
      } else {
        throw const InvalidTokenRecievedException(
            'for safety measures login later, token was not sent from original server');
      }
    } else {
      throw MessageException(response.body);
    }
  }
}
