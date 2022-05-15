import 'package:digital_store_flutter/data/models/custom_exceptions.dart';

import '../../core/global_variables.dart';
import '../../data/models/tokens.dart';
import '../../data/repositories/cart_repository.dart';

Future<bool> checkIfProductIsInTheCart({
  required final String productId,
  required final CartRepository cartRepository,
}) async {
  try {
    Map<String, dynamic> productsMap = await cartRepository.getAllCartItems(
        getTokens
            .get<Tokens>()
            .accessToken); // {products: [{'id': id, 'quantity': quantity}]}
    final List allCartItemProductIds = productsMap['products'];

    if (allCartItemProductIds.any(
        (productIdAndQuantity) => productIdAndQuantity['id'] == productId)) {
      return true;
    } else {
      return false;
    }
  } on InvalidTokenException catch (ex) {
    throw InvalidTokenException(ex.reason);
  }
}

bool checkTokens(final Map<String, dynamic> token) {
  return true;
  // I could check signiture here with original key and determine if tokens were sent from original server
}
