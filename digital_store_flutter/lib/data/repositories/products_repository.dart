import 'dart:convert';

import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/core/services/refresh_authorization_season.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:http/http.dart';

import '../../core/config.dart';
import '../models/custom_exceptions.dart';
import '../models/product.dart';

class ProductsRepository {
  final client = getIt.get<Client>();
  final String startingPath = 'http://$ipAdress:$port/products/';

  Future<List<Product>> getAllProducts() async {
    final response = await client.get(Uri.parse(startingPath));

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
        await client.get(Uri.parse('${startingPath}by-category/$categoryId'));

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
        await client.get(Uri.parse('${startingPath}by-search/$toSearch'));

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

  Future<bool> postNewProduct(final Map<String, dynamic> product) async {
    final response = await client.post(Uri.parse(startingPath),
        body: jsonEncode(product),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return postNewProduct(product);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<Product> getProduct(final String productId) async {
    final response = await client.get(Uri.parse('$startingPath$productId'));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      return Product.fromJson(decodedJson);
    } else {
      throw const MessageException('server error');
    }
  }

  Future<bool> patchProduct(
      final String productId, final Map<String, dynamic> productData) async {
    final response = await client.patch(
      Uri.parse('$startingPath$productId'),
      body: jsonEncode(productData),
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
        return patchProduct(productId, productData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteProduct(final String productId) async {
    final response = await client
        .delete(Uri.parse('$startingPath$productId'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return deleteProduct(productId);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> putProductPurchase(
      final String productId, final Map<String, dynamic> purchaseData) async {
    final response = await client.put(
        Uri.parse('${startingPath}purchase/$productId'),
        body: jsonEncode(purchaseData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return putProductPurchase(productId, purchaseData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> putProductReview(
      final String productId, Map<String, dynamic> reviewData) async {
    final response = await client.put(
        Uri.parse('${startingPath}review/$productId'),
        body: jsonEncode(reviewData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return putProductReview(productId, reviewData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> getAllProductReviews(final String productId) async {
    final response = await client.get(
      Uri.parse('$startingPath$productId'),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshSeason();
        return getAllProductReviews(productId);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }
}
