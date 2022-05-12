import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../models/custom_exceptions.dart';

class CartRepository {
  final String accessToken;
  late final Map<String, String> header;

  CartRepository(final this.accessToken) {
    header = <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer $accessToken'
    };
  }

  final String startingPath = 'http://$ipAdress:$port/cart/';

  Future<Map<String, dynamic>> getAllCartItems() async {
    final response = await http.get(Uri.parse(startingPath), headers: header);

    final Map<String, List<Map<String, dynamic>>> result = {'products': []};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      (decodedJson['products'] as List).forEach((item) {
        result['products']!.add((item as Map<String, dynamic>));
      });
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<bool> postNewCartItem(
      final Map<String, dynamic> productIdAndQuantity) async {
    final response = await http.post(Uri.parse(startingPath),
        headers: header, body: jsonEncode(productIdAndQuantity));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> patchCartItem(
      final String productId, final Map<String, dynamic> productData) async {
    final response = await http.patch(Uri.parse('$startingPath$productId'),
        headers: header, body: jsonEncode(productData));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteCartItem(final String productId) async {
    final response = await http.delete(Uri.parse('$startingPath$productId'),
        headers: header);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> postCheckout() async {
    print('1');
    final response =
        await http.post(Uri.parse('${startingPath}checkout'), headers: header);
    print('2');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteAllCartItems() async {
    final response = await http.delete(
        Uri.parse(
          '${startingPath}clear/all',
        ),
        headers: header);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw const MessageException('server error');
    }
  }
}
