import 'dart:convert';

import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/core/services/refresh_authorization_season.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:http/http.dart';

import '../../core/config.dart';
import '../models/custom_exceptions.dart';
import '../models/user.dart';

class UserRepository {
  final client = getIt.get<Client>();
  final String startingPath = 'http://$ipAdress:$port/user/';

  Future<bool> deleteUser() async {
    final response =
        await client.delete(Uri.parse(startingPath), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return deleteUser();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<List<Map<String, dynamic>>> getAllUserOrders() async {
    final response = await client
        .get(Uri.parse('${startingPath}orders'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    final List<Map<String, dynamic>> result = [];

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (final order in decodedJson) {
        result.add(order as Map<String, dynamic>);
      }
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return getAllUserOrders();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserOrder(final String orderId) async {
    final response = await client.get(
        Uri.parse('${startingPath}orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      result.addAll(decodedJson);
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return getUserOrder(orderId);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<Map<String, dynamic>> getUserBalance() async {
    final response = await client
        .get(Uri.parse('${startingPath}balance'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    final Map<String, dynamic> result = {};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      result.addAll(decodedJson);
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return getUserBalance();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<bool> patchUserBalance(final Map<String, dynamic> balanceData) async {
    final response = await client.patch(Uri.parse('${startingPath}balance'),
        body: jsonEncode(balanceData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return patchUserBalance(balanceData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }
  }

  Future<User> getUserProfile() async {
    final response = await client
        .get(Uri.parse('${startingPath}profile'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      return User.fromJson(decodedJson);
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return getUserProfile();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> patchUserProfile(final Map<String, dynamic> userData) async {
    final response = await client.patch(Uri.parse('${startingPath}profile'),
        body: jsonEncode(userData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return patchUserProfile(userData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }
}
