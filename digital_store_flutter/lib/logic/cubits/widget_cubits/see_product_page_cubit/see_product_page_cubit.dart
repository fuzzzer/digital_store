import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/models/custom_exceptions.dart';
import 'package:digital_store_flutter/data/repositories/cart_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/product.dart';
import '../../../../data/models/user.dart';
import '../../../global_logics/checkers.dart';

part 'see_product_page_state.dart';

class SeeProductPageCubit extends Cubit<SeeProductPageState> {
  SeeProductPageCubit(
      {required final this.productId,
      required final this.userAccessToken,
      required this.productsRepository})
      : super(SeeProductPageInitial()) {
    if (userAccessToken != null) {
      cartRepository = CartRepository(userAccessToken!);
    }
  }

  ProductsRepository productsRepository;
  CartRepository? cartRepository;

  String productId;
  String? userAccessToken;

  void loadProduct() async {
    emit(SeeProductPageLoading());
    try {
      final product = await productsRepository.getProduct(productId);
      bool isInTheCart = false;

      print('a');

      if (userAccessToken != null && cartRepository != null) {
        isInTheCart = await checkIfProductIsInTheCart(
            productId: productId,
            userAccessToken: userAccessToken!,
            cartRepository: cartRepository!);
        print(isInTheCart);
      }

      emit(SeeProductPageLoaded(product: product, isInTheCard: isInTheCart));
    } on MessageException catch (ex) {
      emit(SeeProductPageError(title: ex.reason));
    }
  }

  void addProductToTheCart({required String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      cartRepository!.postNewCartItem({'id': productId, 'quantity': 1});
    }
    loadProduct();
  }

  void deleteCartProduct({required String productId}) async {
    emit(SeeProductPageLoading());
    if (cartRepository != null) {
      cartRepository!.deleteCartItem(productId);
    }
    loadProduct();
  }

  Future<List> buyProduct() async {
    try {
      await productsRepository
          .putProductPurchase(userAccessToken!, productId, {'quantity': 1});
      return [true, ''];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
