part of 'see_product_page_cubit.dart';

abstract class SeeProductPageState extends Equatable {
  const SeeProductPageState();

  @override
  List<Object> get props => [];
}

class SeeProductPageInitial extends SeeProductPageState {}

class SeeProductPageLoading extends SeeProductPageState {}

class SeeProductPageLoaded extends SeeProductPageState {
  final Product product;

  const SeeProductPageLoaded({required final this.product});

  @override
  List<Object> get props => [product];
}

class SeeProductPageError extends SeeProductPageState {
  final String title;
  const SeeProductPageError({final this.title = ''});

  @override
  List<Object> get props => [];
}
