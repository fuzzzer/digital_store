import 'dart:convert';

import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/core/services/refresh_authorization_season.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:http/retry.dart';

import '../../core/config.dart';
import '../models/category.dart';
import '../models/custom_exceptions.dart';

class CategoriesRepository {
  final client = getIt.get<RetryClient>();
  String startingPath = 'http://$ipAdress:$port/categories/';

  Future<List<Category>> getAllCategories() async {
    final response = await client.get(Uri.parse(startingPath));

    if (response.statusCode == 200) {
      final List<Category> result = [];

      final decodedJson = jsonDecode(response.body);

      for (final rawCategory in decodedJson) {
        result.add(Category.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> postNewCategory(final Map<String, dynamic> category) async {
    final response = await client.post(Uri.parse(startingPath),
        body: jsonEncode(category),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return postNewCategory(category);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> patchCategory(
    final String categoryId,
    final Map<String, dynamic> categoryData,
  ) async {
    final response = await client.patch(Uri.parse('$startingPath$categoryId'),
        body: jsonEncode(categoryData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return patchCategory(categoryId, categoryData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteCategory(
    final String categoryId,
  ) async {
    final response = await client.delete(
      Uri.parse('$startingPath$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return deleteCategory(categoryId);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }
}
