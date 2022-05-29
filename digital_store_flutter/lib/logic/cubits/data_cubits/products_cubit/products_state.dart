part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded({required final this.products});

  @override
  List<Object> get props => [products];
}

class ProductsError extends ProductsState {
  final String title;
  final bool sessionEnded;
  const ProductsError({final this.title = '', final this.sessionEnded = false});

  @override
  List<Object> get props => [title, sessionEnded];
}
