import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../models/custom_exceptions.dart';
import '../models/user.dart';

class UserRepository {
  final String startingPath = 'http://$ipAddress:$port/user/';

  Future<bool> deleteUser(final String accessToken) async {
    final response = await http.delete(Uri.parse(startingPath),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }
  }

  Future<List<Map<String, dynamic>>> getAllUserOrders(
      final String accessToken) async {
    final response = await http.get(Uri.parse('${startingPath}orders'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    final List<Map<String, dynamic>> result = [];

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (final order in decodedJson) {
        result.add(order as Map<String, dynamic>);
      }
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserOrder(
      final String accessToken, final String orderId) async {
    final response = await http.get(Uri.parse('${startingPath}orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      result.addAll(decodedJson);
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserBalance(final String accessToken) async {
    final response = await http.get(Uri.parse('${startingPath}balance'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      result.addAll(decodedJson);
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<bool> patchUserBalance(
      final String accessToken, final Map<String, dynamic> balanceData) async {
    final response = await http.patch(Uri.parse('${startingPath}balance'),
        body: jsonEncode(balanceData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw const MessageException('server error');
    }
  }

  Future<User> getUserProfile(final String accessToken) async {
    final response = await http.get(Uri.parse('${startingPath}profile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      return User.fromJson(decodedJson);
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> patchUserProfile(
      final String accessToken, final Map<String, dynamic> userData) async {
    final response = await http.patch(Uri.parse('${startingPath}profile'),
        body: jsonEncode(userData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }
  }
}
