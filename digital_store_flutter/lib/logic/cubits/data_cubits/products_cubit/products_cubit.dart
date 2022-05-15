import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/models/product.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final List<String> selectedCategories = [];
  bool saveOldFilteredProducts =
      false; // this variable becomes true when previus product selection is filtered, and becomes false when previous selection is not filtered

  void loadAllProducts() async {
    emit(ProductsLoading());

    final List<Product> products = await ProductsRepository().getAllProducts();

    saveOldFilteredProducts = false;

    try {
      emit(ProductsLoaded(products: products));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }

  void loadCategorizedProducts({required final String categoryId}) async {
    List<Product>? oldFilteredProducts;

    if (state is ProductsLoaded && saveOldFilteredProducts) {
      oldFilteredProducts = (state as ProductsLoaded).products;
    }

    emit(ProductsLoading());

    selectedCategories.add(categoryId);
    saveOldFilteredProducts = true;

    late final List<Product> products;

    if (oldFilteredProducts != null) {
      products = [
        ...await ProductsRepository().getProductsFilteredByCategory(categoryId),
        ...oldFilteredProducts
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

  void loadSearchedProducts(final String toSearch) async {
    emit(ProductsLoading());

    final List<Product> products =
        await ProductsRepository().getProductsFilteredBySearch(toSearch);

    saveOldFilteredProducts = false;

    try {
      emit(ProductsLoaded(products: products));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }

  void removeFromFilteredProducts({required final String categoryId}) {
    List<Product>? filteredProductsToModify;

    if (state is ProductsLoaded) {
      filteredProductsToModify = (state as ProductsLoaded).products;
    }

    emit(ProductsLoading());

    if (filteredProductsToModify != null) {
      selectedCategories.remove(categoryId);

      filteredProductsToModify.removeWhere((product) {
        return product.categories.contains(categoryId) &&
            !product.categories
                .any((category) => selectedCategories.contains(category));
      });
    }

    try {
      emit(ProductsLoaded(products: filteredProductsToModify!));
    } on MessageException catch (ex) {
      emit(ProductsError(title: ex.reason));
    }
  }
}
