part of 'user_page_cubit.dart';

abstract class UserPageState extends Equatable {
  const UserPageState();

  @override
  List<Object> get props => [];
}

class UserPageInitial extends UserPageState {}

class UserPageLoading extends UserPageState {}

class UserPageWatchingOrders extends UserPageState {
  final List<Product> orderedProducts;

  const UserPageWatchingOrders({
    required this.orderedProducts,
  });

  @override
  List<Object> get props => [orderedProducts];
}

class UserPageError extends UserPageState {
  final String title;
  const UserPageError({this.title = ''});

  @override
  List<Object> get props => [title];
}
