import 'package:dio/dio.dart';

import '../../core/config.dart';
import '../models/category.dart';

class CategoriesRepository {
  final _dio = Dio();

  String startingPath = 'http://$ipAdress:$port/categories/';

  Future<List<Category>> getAllCategories() async {
    final response = await _dio.get(startingPath);

    if (response.statusCode == 200) {
      final List<Category> result = [];

      for (final rawCategory in response.data) {
        result.add(Category.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw Exception('server error');
    }
  }

  Future<bool> postNewCategory(
      final String accessToken, final Map<String, dynamic> category) async {
    final response = await _dio.post(startingPath,
        data: category,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }

  Future<bool> patchCategory(
    final String accessToken,
    final String categoryId,
    final Map<String, dynamic> categoryData,
  ) async {
    final response = await _dio.patch('$startingPath$categoryId',
        data: categoryData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }

  Future<bool> deleteCategory(
    final String accessToken,
    final String categoryId,
  ) async {
    final response = await _dio.delete('$startingPath$categoryId',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data);
    }
  }
}
