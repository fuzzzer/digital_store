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
  final bool isInTheCard;

  const SeeProductPageLoaded(
      {required final this.product, required this.isInTheCard});

  @override
  List<Object> get props => [product, isInTheCard];
}

class SeeProductPageError extends SeeProductPageState {
  final String title;
  const SeeProductPageError({final this.title = ''});

  @override
  List<Object> get props => [];
}
