import 'dart:convert';

import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:digital_store_flutter/core/services/refresh_authorization_season.dart';
import 'package:http/http.dart';

import '../../core/config.dart';
import '../models/custom_exceptions.dart';

// be careful! if you create one instance of this repository and then decide to use that instance everywhere you have to update accessToken when needed
class CartRepository {
  final client = getIt.get<Client>();
  late final Map<String, String> header;

  final String startingPath = 'http://$ipAdress:$port/cart/';

  Future<Map<String, dynamic>> getAllCartItems() async {
    final response =
        await client.get(Uri.parse(startingPath), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    final Map<String, List<Map<String, dynamic>>> result = {'products': []};

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (var item in (decodedJson['products'] as List)) {
        result['products']!.add((item as Map<String, dynamic>));
      }
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        getAllCartItems();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }

    return result;
  }

  Future<bool> postNewCartItem(
      final Map<String, dynamic> productIdAndQuantity) async {
    final response = await client.post(Uri.parse(startingPath),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        },
        body: jsonEncode(productIdAndQuantity));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        return postNewCartItem(productIdAndQuantity);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> patchCartItem(
      final String productId, final Map<String, dynamic> productData) async {
    final response = await client.patch(Uri.parse('$startingPath$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        },
        body: jsonEncode(productData));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        return patchCartItem(productId, productData);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteCartItem(final String productId) async {
    final response = await client
        .delete(Uri.parse('$startingPath$productId'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        return deleteCartItem(productId);
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> postCheckout() async {
    final response = await client
        .post(Uri.parse('${startingPath}checkout'), headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        return postCheckout();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw MessageException(response.body);
    }
  }

  Future<bool> deleteAllCartItems() async {
    final response = await client.delete(
        Uri.parse(
          '${startingPath}clear/all',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${getIt.get<Tokens>().accessToken}'
        });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 &&
        response.body == 'access token is missing or invalid') {
      try {
        await refreshSeason();
        return deleteAllCartItems();
      } on InvalidRefreshTokenException {
        throw const InvalidTokenException('token is invaid or expired');
      }
    } else {
      throw const MessageException('server error');
    }
  }
}
