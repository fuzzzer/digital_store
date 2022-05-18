import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/data/models/tokens.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/cart_repository.dart';
import '../../../global_logics/refresh_authorization_season.dart';

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
      Map<String, dynamic> allCartItemProductIds = await cartRepository
          .getAllCartItems(getTokens.get<Tokens>().accessToken);

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
      try {
        refreshSeason(authenticationRepository);

        loadCartItems();
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    } on MessageException catch (ex) {
      emit(CartError(title: ex.reason));
    }
  }

  void incrementCartProduct(final Product product) {
    try {
      final int newQuantity = product.quantityInTheCart! + 1;
      cartRepository.patchCartItem(getTokens.get<Tokens>().accessToken,
          product.id, {'quantity': newQuantity});
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);

        incrementCartProduct(product);
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    }
    loadCartItems();
  }

  Future<List> decrementCartProduct(final Product product) async {
    try {
      final int newQuantity = product.quantityInTheCart! - 1;
      await cartRepository.patchCartItem(getTokens.get<Tokens>().accessToken,
          product.id, {'quantity': newQuantity});
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        decrementCartProduct(product);
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
    loadCartItems();
    return [true, ''];
  }

  void deleteCartProduct(final String productId) {
    try {
      cartRepository.deleteCartItem(
          getTokens.get<Tokens>().accessToken, productId);
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        deleteCartProduct(productId);
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    }
    loadCartItems();
  }

  void clearCart() {
    try {
      cartRepository.deleteAllCartItems(getTokens.get<Tokens>().accessToken);
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);

        clearCart();
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    }
    loadCartItems();
  }

  bool addCartProduct({
    required final String productId,
    required final int quantity,
  }) {
    try {
      cartRepository.postNewCartItem(getTokens.get<Tokens>().accessToken,
          {'id': productId, 'quantity': quantity});
      return true;
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        return addCartProduct(productId: productId, quantity: quantity);
      } on InvalidRefreshTokenException {
        sessionExpired();
        return false;
      }
    } on MessageException {
      return false;
    }
  }

  Future<List> cartCheckout() async {
    try {
      await cartRepository.postCheckout(getTokens.get<Tokens>().accessToken);
      loadCartItems();
      return [true, 'Successful payment'];
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        return cartCheckout();
      } on InvalidRefreshTokenException catch (ex) {
        sessionExpired();
        return [false, ex.reason];
      }
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
