import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/models/product.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  void loadProducts() async {
    emit(HomePageLoading());

    List<Product> products = await ProductsRepository().getAllProducts();
    try {
      emit(HomePageLoaded(products: products));
    } on Exception catch (ex) {
      emit(HomePageError(title: ex.toString()));
    }
  }
}
