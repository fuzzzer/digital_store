part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Product> productsWithCartQuantity;
  final double totalCartPrice;

  const CartLoaded(
      {required this.productsWithCartQuantity, required this.totalCartPrice});

  @override
  List<Object> get props => [productsWithCartQuantity, totalCartPrice];
}

class CartError extends CartState {
  final String title;
  const CartError({this.title = ''});

  @override
  List<Object> get props => [title];
}
