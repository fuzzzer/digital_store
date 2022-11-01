part of 'product_page_cubit.dart';

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
      {required this.product, required this.isInTheCard});

  @override
  List<Object> get props => [product, isInTheCard];
}

class SeeProductPageError extends SeeProductPageState {
  final String title;
  const SeeProductPageError({this.title = ''});

  @override
  List<Object> get props => [];
}
