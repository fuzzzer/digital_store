import 'package:dio/dio.dart';

import '../../core/config.dart';
import '../models/custom_exceptions.dart';
import '../models/product.dart';

class ProductsRepository {
  final _dio = Dio();

  final String startingPath = 'http://$ipAdress:$port/products/';

  Future<List<Product>> getAllProducts() async {
    final response = await _dio.get(startingPath);

    if (response.statusCode == 200) {
      final List<Product> result = [];

      for (final rawCategory in response.data) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<List<Product>> getProductsFilteredByCategory(String categoryId) async {
    final response = await _dio.get('${startingPath}by-category/$categoryId');

    if (response.statusCode == 200) {
      final List<Product> result = [];

      for (final rawCategory in response.data) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<List<Product>> getProductsFilteredBySearch(String toSearch) async {
    final response = await _dio.get('${startingPath}by-search/$toSearch');

    if (response.statusCode == 200) {
      final List<Product> result = [];

      for (final rawCategory in response.data) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> postNewProduct(
      final String accessToken, final Map<String, dynamic> product) async {
    final response = await _dio.post(startingPath,
        data: product,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<Product> getProduct(final String productId) async {
    final response = await _dio.get('$startingPath$productId');

    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> patchProduct(final String accessToken, final String productId,
      final Map<String, dynamic> productData) async {
    final response = await _dio.patch('$startingPath$productId',
        data: productData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> deleteProduct(
      final String accessToken, final String productId) async {
    final response = await _dio.delete('$startingPath$productId',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> putProductPurchase(final String accessToken,
      final String productId, final Map<String, dynamic> purchaseData) async {
    final response = await _dio.put('${startingPath}purchase/$productId',
        data: purchaseData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> putProductReview(final String accessToken,
      final String productId, Map<String, dynamic> reviewData) async {
    final response = await _dio.put('${startingPath}review/$productId',
        data: reviewData,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> getAllProductReviews(final String productId) async {
    final response = await _dio.get(
      '$startingPath$productId',
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }
}
