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

part 'see_product_page_state.dart';

class SeeProductPageCubit extends Cubit<SeeProductPageState> {
  SeeProductPageCubit(
      {required final this.productId,
      required this.productsRepository,
      required this.authenticationRepository})
      : super(SeeProductPageInitial()) {
    if (getIt.get<Tokens>().accessToken != '') {
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
      emit(const SeeProductPageError(
          title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(SeeProductPageError(title: ex.reason));
    }
  }

  Future<void> addCartProduct({required final String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      try {
        await cartRepository!.postNewCartItem({'id': productId, 'quantity': 1});
      } on InvalidTokenException {
        emit(const SeeProductPageError(
            title: 'please relogin', sessionEnded: true));
      } on MessageException catch (ex) {
        emit(SeeProductPageError(title: ex.reason));
      }
    }
    loadProduct();
  }

  Future<void> deleteCartProduct({required final String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      try {
        await cartRepository!.deleteCartItem(productId);
      } on InvalidTokenException {
        emit(const SeeProductPageError(
            title: 'please relogin', sessionEnded: true));
      } on MessageException catch (ex) {
        emit(SeeProductPageError(title: ex.reason));
      }
    }
    loadProduct();
  }

  Future<List> buyProduct() async {
    try {
      await productsRepository.putProductPurchase(productId, {'quantity': 1});
      loadProduct();
      return [true, 'Successful payment'];
    } on InvalidTokenException {
      emit(const SeeProductPageError(
          title: 'please relogin', sessionEnded: true));
      return [false, ''];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
