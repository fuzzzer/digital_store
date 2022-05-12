import '../../data/repositories/cart_repository.dart';

Future<bool> checkIfProductIsInTheCart({
  required final String productId,
  required final String userAccessToken,
  required final CartRepository cartRepository,
}) async {
  Map<String, dynamic> productsMap = await cartRepository
      .getAllCartItems(); // {products: [{'id': id, 'quantity': quantity}]}

  final List allCartItemProductIds = productsMap['products'];

  if (allCartItemProductIds
      .any((productIdAndQuantity) => productIdAndQuantity['id'] == productId)) {
    return true;
  } else {
    return false;
  }
}
