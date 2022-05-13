import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../models/custom_exceptions.dart';

// be careful! if you create one instance of this repository and then decide to use that instance everywhere you have to update accessToken when needed
class CartRepository {
  late final Map<String, String> header;

  final String startingPath = 'http://$ipAdress:$port/cart/';

  Future<Map<String, dynamic>> getAllCartItems(String accessToken) async {
    final response = await http.get(Uri.parse(startingPath),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        });

    final Map<String, List<Map<String, dynamic>>> result = {'products': []};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (var item in (decodedJson['products'] as List)) {
        result['products']!.add((item as Map<String, dynamic>));
      }
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }

    return result;
  }

  Future<bool> postNewCartItem(String accessToken,
      final Map<String, dynamic> productIdAndQuantity) async {
    final response = await http.post(Uri.parse(startingPath),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(productIdAndQuantity));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> patchCartItem(String accessToken, final String productId,
      final Map<String, dynamic> productData) async {
    final response = await http.patch(Uri.parse('$startingPath$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(productData));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw const InvalidTokenException('invaid or expired');
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteCartItem(
      String accessToken, final String productId) async {
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

  Future<bool> postCheckout(String accessToken) async {
    final response = await http.post(Uri.parse('${startingPath}checkout'),
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

  Future<bool> deleteAllCartItems(String accessToken) async {
    final response = await http.delete(
        Uri.parse(
          '${startingPath}clear/all',
        ),
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
}
