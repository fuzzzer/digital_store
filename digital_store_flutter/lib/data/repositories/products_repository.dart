import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../models/custom_exceptions.dart';
import '../models/product.dart';

class ProductsRepository {
  final String startingPath = 'http://$ipAddress:$port/products/';

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(startingPath));

    if (response.statusCode == 200) {
      final List<Product> result = [];

      final decodedJson = jsonDecode(response.body);

      for (final rawCategory in decodedJson) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<List<Product>> getProductsFilteredByCategory(String categoryId) async {
    final response =
        await http.get(Uri.parse('${startingPath}by-category/$categoryId'));

    if (response.statusCode == 200) {
      final List<Product> result = [];

      final decodedJson = jsonDecode(response.body);

      for (final rawCategory in decodedJson) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<List<Product>> getProductsFilteredBySearch(String toSearch) async {
    final response =
        await http.get(Uri.parse('${startingPath}by-search/$toSearch'));

    if (response.statusCode == 200) {
      final List<Product> result = [];

      final decodedJson = jsonDecode(response.body);

      for (final rawCategory in decodedJson) {
        result.add(Product.fromJson(rawCategory as Map<String, dynamic>));
      }

      return result;
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> postNewProduct(
      final String accessToken, final Map<String, dynamic> product) async {
    final response = await http.post(Uri.parse(startingPath),
        body: jsonEncode(product),
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

  Future<Product> getProduct(final String productId) async {
    final response = await http.get(Uri.parse('$startingPath$productId'));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      return Product.fromJson(decodedJson);
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> patchProduct(final String accessToken, final String productId,
      final Map<String, dynamic> productData) async {
    final response = await http.patch(Uri.parse('$startingPath$productId'),
        body: jsonEncode(productData),
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

  Future<bool> deleteProduct(
      final String accessToken, final String productId) async {
    final response = await http.delete(Uri.parse('$startingPath$productId'),
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

  Future<bool> putProductPurchase(final String accessToken,
      final String productId, final Map<String, dynamic> purchaseData) async {
    final response = await http.put(
        Uri.parse('${startingPath}purchase/$productId'),
        body: jsonEncode(purchaseData),
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

  Future<bool> putProductReview(final String accessToken,
      final String productId, Map<String, dynamic> reviewData) async {
    final response = await http.put(
        Uri.parse('${startingPath}review/$productId'),
        body: jsonEncode(reviewData),
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

  Future<bool> getAllProductReviews(final String productId) async {
    final response = await http.get(
      Uri.parse('$startingPath$productId'),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }
  }
}
