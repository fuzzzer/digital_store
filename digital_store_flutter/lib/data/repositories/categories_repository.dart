import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../models/category.dart';
import '../models/custom_exceptions.dart';

class CategoriesRepository {
  String startingPath = 'http://$ipAdress:$port/categories/';

  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse(startingPath));

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

  Future<bool> postNewCategory(
      final String accessToken, final Map<String, dynamic> category) async {
    final response = await http.post(Uri.parse(startingPath),
        body: jsonEncode(category),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> patchCategory(
    final String accessToken,
    final String categoryId,
    final Map<String, dynamic> categoryData,
  ) async {
    final response = await http.patch(Uri.parse('$startingPath$categoryId'),
        body: jsonEncode(categoryData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteCategory(
    final String accessToken,
    final String categoryId,
  ) async {
    final response = await http.delete(Uri.parse('$startingPath$categoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }
}
