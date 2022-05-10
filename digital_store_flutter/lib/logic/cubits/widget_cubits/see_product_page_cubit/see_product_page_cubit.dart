import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/product.dart';

part 'see_product_page_state.dart';

class SeeProductPageCubit extends Cubit<SeeProductPageState> {
  SeeProductPageCubit({required final this.productId})
      : super(SeeProductPageInitial());

  String productId;

  void loadProduct() async {
    emit(SeeProductPageLoading());
    try {
      final product = await ProductsRepository().getProduct(productId);
      emit(SeeProductPageLoaded(product: product));
    } on Exception catch (ex) {
      emit(SeeProductPageError(title: ex.toString()));
    }
  }
}
