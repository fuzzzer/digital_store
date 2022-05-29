import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(
      {required final this.cartRepository,
      required final this.productsRepository,
      required final this.authenticationRepository})
      : super(CartInitial());

  final CartRepository cartRepository;
  final ProductsRepository productsRepository;
  final AuthenticationRepository authenticationRepository;

  void loadCartItems() async {
    //todo: it will be good to do the sorting on cart items
    emit(CartLoading());

    try {
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

      final List<Product> productsWithCartQuantity = [];

      double totalCartPrice = 0;

      for (int i = 0; i < products.length; i++) {
        productsWithCartQuantity
            .add(products[i].copyWith(quantityInTheCart: productQuantities[i]));

        totalCartPrice += productsWithCartQuantity[i].price *
            productsWithCartQuantity[i].quantityInTheCart!;
      }

      emit(CartLoaded(
          productsWithCartQuantity: productsWithCartQuantity,
          totalCartPrice: totalCartPrice));
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
  }

  Future<List> incrementCartProduct(final Product product) async {
    try {
      final int newQuantity = product.quantityInTheCart! + 1;
      await cartRepository.patchCartItem(product.id, {'quantity': newQuantity});
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
    loadCartItems();
    return [true, ''];
  }

  Future<List> decrementCartProduct(final Product product) async {
    try {
      final int newQuantity = product.quantityInTheCart! - 1;
      await cartRepository.patchCartItem(product.id, {'quantity': newQuantity});
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
    loadCartItems();
    return [true, ''];
  }

  Future<void> deleteCartProduct(final String productId) async {
    try {
      await cartRepository.deleteCartItem(productId);
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
    loadCartItems();
  }

  void clearCart() async {
    try {
      await cartRepository.deleteAllCartItems();
      loadCartItems();
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
    loadCartItems();
  }

  Future<bool> addCartProduct({
    required final String productId,
    required final int quantity,
  }) async {
    try {
      await cartRepository
          .postNewCartItem({'id': productId, 'quantity': quantity});
      return true;
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
      return false;
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
      return false;
    }
  }

  Future<List> cartCheckout() async {
    try {
      await cartRepository.postCheckout();
      loadCartItems();
      return [true, 'Successful payment'];
    } on InvalidTokenException {
      emit(const CartError(title: 'please relogin', sessionEnded: true));
      return [false, ''];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
