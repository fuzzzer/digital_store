import 'package:dio/dio.dart';

import '../../core/config.dart';
import '../models/custom_exceptions.dart';

class CartRepository {
  final _dio = Dio();

  final String accessToken;

  CartRepository(final this.accessToken) {
    _dio.options.headers['authorization'] = 'Bearer $accessToken';
  }

  final String startingPath = 'http://$ipAdress:$port/cart/';

  Future<Map<String, dynamic>> getAllCartItems() async {
    final response = await _dio.get(startingPath,
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    final Map<String, List<Map<String, dynamic>>> result = {'products': []};

    if (response.statusCode == 200) {
      (response.data['products'] as List).forEach((item) {
        result['products']!.add((item as Map<String, dynamic>));
      });
    } else {
      throw const MessageException('server error');
    }

    return result;
  }

  Future<bool> postNewCartItem(final Map<String, dynamic> product) async {
    final response = await _dio.post(startingPath, data: product);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> patchCartItem(
      final String productId, final Map<String, dynamic> productData) async {
    final response =
        await _dio.patch('$startingPath$productId', data: productData);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> deleteCartItem(final String productId) async {
    final response = await _dio.delete('$startingPath$productId');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> postCheckout() async {
    final response = await _dio.post('${startingPath}checkout');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw MessageException(response.data);
    }
  }

  Future<bool> deleteAllCartItems() async {
    final response = await _dio.post('${startingPath}clear/all');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw const MessageException('server error');
    }
  }
}
