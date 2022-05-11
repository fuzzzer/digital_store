import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void loadCartItems(String accessToken) async {
    //todo: it will be good to do the sorting on cart items
    emit(CartLoading());

    Map<String, dynamic> allCartItemProductIds =
        await CartRepository(accessToken).getAllCartItems();

    final List<Map<String, dynamic>> productIds =
        allCartItemProductIds['products'] as List<Map<String, dynamic>>;

    final List<Future<Product>> productFutures = [];
    final List<int> productQuantities = [];

    for (int i = 0; i < productIds.length; i++) {
      final currentRawProduct =
          ProductsRepository().getProduct(productIds[i]['id']);

      productFutures.add(currentRawProduct);
      productQuantities.add(productIds[i]['quantity']);
    }

    final List<Product> products = await Future.wait(productFutures);

    List<Product> productsWithCartQuantity = [];

    for (int i = 0; i < products.length; i++) {
      productsWithCartQuantity
          .add(products[i].copyWith(quantityInTheCart: productQuantities[i]));
    }

    try {
      emit(CartLoaded(productsWithCartQuantity: productsWithCartQuantity));
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
  }

  void incrementCartProduct(Product product, String accessToken) {
    int newQuantity = product.quantityInTheCart! + 1;
    CartRepository(accessToken)
        .patchCartItem(product.id, {'quantity': newQuantity});
    loadCartItems(accessToken);
  }

  void decrementCartProduct(Product product, String accessToken) {
    int newQuantity = product.quantityInTheCart! - 1;
    CartRepository(accessToken)
        .patchCartItem(product.id, {'quantity': newQuantity});
    loadCartItems(accessToken);
  }

  void deleteCartProduct(Product product, String accessToken) {
    CartRepository(accessToken).deleteCartItem(product.id);
    loadCartItems(accessToken);
  }

  bool addCartProduct(Product product, String accessToken) {
    try {
      CartRepository(accessToken).postNewCartItem(
          {'id': product.id, 'quantity': product.quantityInTheCart});
      return true;
    } on MessageException{
      return false;
    }
  }
}
