import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/core/global_variables.dart';
import 'package:digital_store_flutter/data/models/custom_exceptions.dart';
import 'package:digital_store_flutter/data/repositories/cart_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/product.dart';
import '../../../../data/models/tokens.dart';
import '../../../../data/repositories/authentication_repository.dart';
import '../../../global_logics/checkers.dart';
import '../../../global_logics/refresh_authorization_season.dart';

part 'see_product_page_state.dart';

class SeeProductPageCubit extends Cubit<SeeProductPageState> {
  SeeProductPageCubit(
      {required final this.productId,
      required this.productsRepository,
      required this.authenticationRepository})
      : super(SeeProductPageInitial()) {
    if (getTokens.get<Tokens>().accessToken != '') {
      cartRepository = CartRepository();
    }
  }

  ProductsRepository productsRepository;
  CartRepository? cartRepository;
  AuthenticationRepository authenticationRepository;

  String productId;

  void loadProduct() async {
    emit(SeeProductPageLoading());
    try {
      final product = await productsRepository.getProduct(productId);

      bool isInTheCart = false;

      if (cartRepository != null) {
        isInTheCart = await checkIfProductIsInTheCart(
            productId: productId, cartRepository: cartRepository!);
      }

      emit(SeeProductPageLoaded(product: product, isInTheCard: isInTheCart));
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);

        loadProduct();
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    } on MessageException catch (ex) {
      emit(SeeProductPageError(title: ex.reason));
    }
  }

  void addProductToTheCart({required String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      try {
        cartRepository!.postNewCartItem(getTokens.get<Tokens>().accessToken,
            {'id': productId, 'quantity': 1});
      } on InvalidTokenException {
        try {
          refreshSeason(authenticationRepository);
          addProductToTheCart(productId: productId);
        } on InvalidRefreshTokenException {
          sessionExpired();
        }
      }
    }
    loadProduct();
  }

  void deleteCartProduct({required String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      try {
        cartRepository!
            .deleteCartItem(getTokens.get<Tokens>().accessToken, productId);
      } on InvalidTokenException {
        try {
          refreshSeason(authenticationRepository);
          deleteCartProduct(productId: productId);
        } on InvalidRefreshTokenException {
          sessionExpired();
        }
      }
    }
    loadProduct();
  }

  Future<List> buyProduct() async {
    try {
      await productsRepository.putProductPurchase(
          getTokens.get<Tokens>().accessToken, productId, {'quantity': 1});
      loadProduct();
      return [true, 'Successful payment'];
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        return buyProduct();
      } on InvalidRefreshTokenException {
        sessionExpired();
        return [false, ''];
      }
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
