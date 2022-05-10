import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/models/product.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  List<String> selectedCategories = [];
  bool saveOldProducts =
      false; // this variable becomes true when previus product selection is filtered, and becomes false when previous selection is not filtered

  void loadAllProducts() async {
    emit(ProductsLoading());

    final List<Product> products = await ProductsRepository().getAllProducts();

    saveOldProducts = false;

    try {
      emit(ProductsLoaded(products: products));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }

  void loadCategorizedProducts({required String categoryId}) async {
    List<Product>? productsToSave;

    if (state is ProductsLoaded && saveOldProducts) {
      productsToSave = (state as ProductsLoaded).products;
    }

    emit(ProductsLoading());

    selectedCategories.add(categoryId);
    saveOldProducts = true;

    late final List<Product> products;

    if (productsToSave != null) {
      products = [
        ...await ProductsRepository().getProductsFilteredByCategory(categoryId),
        ...productsToSave
      ];
    } else {
      products =
          await ProductsRepository().getProductsFilteredByCategory(categoryId);
    }

    try {
      emit(ProductsLoaded(products: products));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }

  void loadSearchedProducts(String toSearch) async {
    emit(ProductsLoading());

    final List<Product> products =
        await ProductsRepository().getProductsFilteredBySearch(toSearch);

    saveOldProducts = false;

    try {
      emit(ProductsLoaded(products: products));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }

  void removeProducts({required String categoryId}) {
    List<Product>? productsToModify;

    if (state is ProductsLoaded) {
      productsToModify = (state as ProductsLoaded).products;
    }

    emit(ProductsLoading());

    if (productsToModify != null) {
      selectedCategories.remove(categoryId);

      productsToModify.removeWhere((product) {
        return product.categories.contains(categoryId) &&
            !product.categories
                .any((category) => selectedCategories.contains(category));
      });
    }

    try {
      emit(ProductsLoaded(products: productsToModify!));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }
}
