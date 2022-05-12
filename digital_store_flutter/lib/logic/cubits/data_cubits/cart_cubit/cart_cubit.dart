import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.cartRepository}) : super(CartInitial());

  CartRepository cartRepository;
  ProductsRepository productsRepository = ProductsRepository();

  void loadCartItems() async {
    //todo: it will be good to do the sorting on cart items
    emit(CartLoading());

    Map<String, dynamic> allCartItemProductIds =
        await cartRepository.getAllCartItems();

    final List<Map<String, dynamic>> productIds =
        allCartItemProductIds['products'] as List<Map<String, dynamic>>;

    final List<Future<Product>> productFutures = [];
    final List<int> productQuantities = [];

    for (int i = 0; i < productIds.length; i++) {
      final currentRawProduct =
          productsRepository.getProduct(productIds[i]['id']);

      productFutures.add(currentRawProduct);
      productQuantities.add(productIds[i]['quantity']);
    }

    final List<Product> products = await Future.wait(productFutures);

    List<Product> productsWithCartQuantity = [];

    double totalCartPrice = 0;

    for (int i = 0; i < products.length; i++) {
      productsWithCartQuantity
          .add(products[i].copyWith(quantityInTheCart: productQuantities[i]));

      totalCartPrice += productsWithCartQuantity[i].price *
          productsWithCartQuantity[i].quantityInTheCart!;
    }

    try {
      emit(CartLoaded(
          productsWithCartQuantity: productsWithCartQuantity,
          totalCartPrice: totalCartPrice));
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
  }

  void incrementCartProduct(Product product) {
    int newQuantity = product.quantityInTheCart! + 1;
    cartRepository.patchCartItem(product.id, {'quantity': newQuantity});
    loadCartItems();
  }

  void decrementCartProduct(Product product) {
    int newQuantity = product.quantityInTheCart! - 1;
    cartRepository.patchCartItem(product.id, {'quantity': newQuantity});
    loadCartItems();
  }

  void deleteCartProduct(Product product) {
    cartRepository.deleteCartItem(product.id);
    loadCartItems();
  }

  void clearCart() {
    cartRepository.deleteAllCartItems();
    loadCartItems();
  }

  bool addCartProduct(Product product) {
    try {
      cartRepository.postNewCartItem(
          {'id': product.id, 'quantity': product.quantityInTheCart});
      return true;
    } on MessageException {
      return false;
    }
  }

  Future<List> cartCheckout() async {
    try {
      await cartRepository.postCheckout();
      return [true, ''];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
