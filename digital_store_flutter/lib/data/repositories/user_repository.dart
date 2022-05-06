import 'package:dio/dio.dart';

import '../../core/config.dart';
import '../models/user.dart';

class UserRepository {
  final _dio = Dio();

  final String startingPath = 'http://$ipAdress:$port/user/';

  Future<bool> deleteUser(final String accessToken) async {
    final response = await _dio.delete(startingPath,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }

  Future<Map<String, dynamic>> getAllUserOrders(
      final String accessToken) async {
    final response = await _dio.get('${startingPath}orders',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      result.addAll(response.data);
    } else {
      throw Exception('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserOrder(
      final String accessToken, final String orderId) async {
    final response = await _dio.get('${startingPath}orders/$orderId',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      result.addAll(response.data);
    } else {
      throw Exception('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserBalance(final String accessToken) async {
    final response = await _dio.get('${startingPath}balance',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      result.addAll(response.data);
    } else {
      throw Exception('server error');
    }

    return result;
  }

  Future<bool> patchUserBalance(
      final String accessToken, final Map<String, dynamic> balanceData) async {
    final response = await _dio.patch('${startingPath}balance',
        data: balanceData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('server error');
    }
  }

  Future<User> getUserProfile(final String accessToken) async {
    final response = await _dio.get('${startingPath}profile',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('server error');
    }
  }

  Future<bool> patchUserProfile(
      final String accessToken, final Map<String, dynamic> userData) async {
    final response = await _dio.patch('${startingPath}profile',
        data: userData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }
}
