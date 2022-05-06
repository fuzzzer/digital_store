import 'package:dio/dio.dart';

import '../../core/config.dart';
import '../../logic/checks.dart';
import '../models/custom_exceptions.dart';

class AuthenticationRepository {
  final _dio = Dio();

  final String startingPath = 'http://$ipAdress:$port/authentication/';

  Future<Map<String, dynamic>> postRefresh(final String refreshToken) async {
    final response = await _dio
        .post('${startingPath}refresh', data: {'refreshToken': refreshToken});

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      if (checkTokens(response.data)) {
        result.addAll(response.data);
      } else {
        throw const InvalidTokenException(
            'token recieved was not sent from original server');
      }
    } else if (response.statusCode == 400) {
      throw Exception(response.data);
    }

    return result;
  }

  Future<bool> postsignUp(final Map<String, dynamic> newUser) async {
    final response = await _dio.post('${startingPath}sign-up', data: newUser);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }

  Future<Map<String, dynamic>> postSignIn(
      final Map<String, dynamic> userCredentials) async {
    final response =
        await _dio.post('${startingPath}sign-in', data: userCredentials);
    if (response.statusCode == 200) {
      if (true
          // checkTokens(response.data)
          ) {
        return response.data as Map<String, dynamic>;
      }
      // else {
      //   throw InvalidTokenException(
      //       'token recieved was not sent from original server');
      // }
    } else {
      throw Exception(response.data);
    }
  }
}
