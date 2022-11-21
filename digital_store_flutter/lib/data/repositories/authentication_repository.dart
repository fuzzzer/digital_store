import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../../logic/global_logics/checkers.dart';
import '../models/custom_exceptions.dart';

class AuthenticationRepository {
  final String startingPath = 'http://$ipAddress:$port/authentication/';

  Future<Map<String, dynamic>> postRefresh(final String refreshToken) async {
    final response = await http.post(Uri.parse('${startingPath}refresh'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      if (checkTokens(decodedJson)) {
        return decodedJson as Map<String, dynamic>;
      } else {
        throw const InvalidTokenRecievedException(
            'for safety measures login later, token was not sent from original server');
      }
    } else if (response.statusCode == 400) {
      throw const InvalidRefreshTokenException('season timeout');
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> postsignUp(final Map<String, dynamic> newUser) async {
    final response = await http.post(Uri.parse('${startingPath}sign-up'),
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
    final response = await http.post(Uri.parse('${startingPath}sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userCredentials));
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      if (checkTokens(decodedJson)) {
        return decodedJson as Map<String, dynamic>;
      } else {
        throw const InvalidTokenRecievedException(
            'for safety measures login later, token was not sent from original server');
      }
    } else {
      throw MessageException(response.body);
    }
  }
}
