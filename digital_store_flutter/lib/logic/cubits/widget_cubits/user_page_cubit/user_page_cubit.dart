import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/models/custom_exceptions.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/product.dart';

import '../../../../data/repositories/authentication_repository.dart';

part 'user_page_state.dart';

class UserPageCubit extends Cubit<UserPageState> {
  UserPageCubit(
      {required this.userRepository,
      required this.productsRepository,
      required this.authenticationRepository})
      : super(UserPageInitial());

  UserRepository userRepository;
  ProductsRepository productsRepository;
  AuthenticationRepository authenticationRepository;

  void changeWatchingOrdersState() async {
    if (state is UserPageWatchingOrders) {
      emit(UserPageInitial());
    } else {
      loadOrders();
    }
  }

  void loadOrders() async {
    emit(UserPageLoading());

    try {
      List<Map<String, dynamic>> allOrdersDataData =
          await userRepository.getAllUserOrders();

      List<Future<Product>> allFutureProductsWithoutCartQuantity = [];
      List<Map<String, dynamic>> productQuantitiesAndPrices = [];

      for (final orderData in allOrdersDataData) {
        Future<Product> futureProductWithoutCartQuantity =
            productsRepository.getProduct(orderData['id']);

        allFutureProductsWithoutCartQuantity
            .add(futureProductWithoutCartQuantity);
        productQuantitiesAndPrices.add(
            {'quantity': orderData['quantity'], 'price': orderData['price']});
      }

      List<Product> allProductsWithoutCartQuantity =
          await Future.wait(allFutureProductsWithoutCartQuantity);

      List<Product> orderedProducts = [];

      for (int i = 0; i < allProductsWithoutCartQuantity.length; i++) {
        final currentToAdd = allProductsWithoutCartQuantity[i].copyWith(
            price: productQuantitiesAndPrices[i]['price'],
            quantityInTheCart: productQuantitiesAndPrices[i]['quantity']);

        orderedProducts.add(currentToAdd);
      }

      emit(UserPageWatchingOrders(orderedProducts: orderedProducts));
    } on InvalidTokenException {
      emit(const UserPageError(title: 'please relogin', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(UserPageError(title: ex.reason));
    }
  }
}
